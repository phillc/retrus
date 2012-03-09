(function() {
  var File, Hook, Pathfinder, Project, Watcher, async, fs, mint;
  var __slice = Array.prototype.slice;

  Hook = require("hook.io").Hook;

  Pathfinder = require('pathfinder');

  File = Pathfinder.File;

  Watcher = require("./watcher");

  async = require('async');

  fs = require('fs');

  mint = require('mint');

  Project = (function() {

    Project.store = function() {
      return this._store || (this._store = {});
    };

    Project.all = Project.store;

    Project.timeout = 10 * 1000;

    Project.find = function(namespace) {
      var cwd, project, _ref;
      if (namespace) {
        return this.all()[namespace];
      } else {
        cwd = process.cwd();
        _ref = this.all();
        for (namespace in _ref) {
          project = _ref[namespace];
          if (project.root === cwd) return project;
        }
        return null;
      }
    };

    Project.prototype.replacer = function(key, value) {
      if (value instanceof RegExp) {
        return "(function() { return new RegExp('" + value + "') })";
      } else if (typeof value === "function") {
        return "(" + value + ")";
      } else {
        return value;
      }
    };

    Project.prototype.reviver = function(key, value) {
      if (typeof value === "string" && !!value.match(/^(?:\(function\s*\([^\)]*\)\s*\{|\(\/)/) && !!value.match(/(?:\}\s*\)|\/\w*\))$/)) {
        return eval(value);
      } else {
        return value;
      }
    };

    function Project(options) {
      var store;
      if (options == null) options = {};
      this.root = File.absolutePath(options.root);
      this.namespace = options.namespace;
      this.watchfile = File.absolutePath(options.watchfile);
      this.pathfinder = new Pathfinder(this.root);
      this.ignoredPaths = [];
      this.watchers = [];
      this.growl = options.growl !== false;
      Watcher.pathfinder = this.pathfinder;
      if (!this.watchfile) throw new Error("You must specify the watchfile");
      if (!this.root) throw new Error("You must specify the directory to watch");
      store = this.constructor.store();
      if (store.hasOwnProperty(this.namespace)) {
        throw new Error("Only one project per namespace");
      }
      store[this.namespace] = this;
      this.hook = new Hook({
        name: "design.io-watcher::" + this.namespace,
        debug: true,
        silent: false
      });
    }

    Project.prototype.watch = function() {
      var hook;
      var _this = this;
      hook = this.hook;
      hook.on("hook::ready", function(data) {
        hook.emit("ready", data);
        _this.read(function() {
          return new (require('./listener/mac'))({
            root: _this.root,
            ignore: _this.ignoredPaths
          }, function(path, options) {
            var _i, _len, _ref, _results;
            options.namespace = _this.namespace;
            options.paths = path instanceof Array ? path : [path];
            _ref = options.paths;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              path = _ref[_i];
              _results.push(_this.changed(path, options));
            }
            return _results;
          });
        });
        return _this;
      });
      hook.on("design.io-server::stop", function() {
        return hook.stop();
      });
      hook.on("design.io-server::connect", function(data, callback) {
        _this.connect();
        return callback();
      });
      hook.start();
      return this;
    };

    Project.prototype.createWatcher = function() {
      return this.watchers.push((function(func, args, ctor) {
        ctor.prototype = func.prototype;
        var child = new ctor, result = func.apply(child, args);
        return typeof result === "object" ? result : child;
      })(Watcher, [this].concat(__slice.call(arguments)), function() {}));
    };

    Project.prototype.read = function(callback) {
      var _this = this;
      Watcher.ignoredPaths = [];
      return fs.readFile(this.watchfile, "utf-8", function(error, result) {
        var Module, mainModule, paths;
        mainModule = require.main;
        paths = mainModule.paths;
        mainModule.moduleCache && (mainModule.moduleCache = {});
        mainModule.filename = '.';
        if (process.binding('natives').module) {
          Module = require('module').Module;
          mainModule.paths = Module._nodeModulePaths(File.dirname(_this.watchfile));
        }
        result = "__project = require(\"design.io/lib/design.io/project\").find(\"" + _this.namespace + "\")\n\nignorePaths = ->\n  __project.ignoredPaths ||= []\n  __project.ignoredPaths = __project.ignoredPaths.concat Array.prototype.slice.call(arguments, 0, arguments.length)\n\nwatch = ->\n  __project.createWatcher(arguments...)\n\n" + result;
        return mint.coffee(result, {}, function(error, result) {
          mainModule._compile(result, mainModule.filename);
          if (callback) return callback.call(_this);
        });
      });
    };

    Project.prototype.changed = function(path, options) {
      if (options == null) options = {};
      return this.queue.push({
        binding: this,
        path: path,
        options: options
      });
    };

    Project.prototype.queue = async.queue(function(change, callback) {
      return change.binding.change(change.path, change.options, callback);
    }, 1);

    Project.prototype.change = function(path, options, callback) {
      var iterator, watchers;
      watchers = this.watchers;
      options.duration || (options.duration = this.constructor.timeout);
      iterator = function(watcher, next) {
        return watcher.invoke(path, options, next);
      };
      return async.forEachSeries(watchers, iterator, function(error) {
        return process.nextTick(callback);
      });
    };

    Project.prototype.toJSON = function() {
      var data, watcher, watchers, _i, _len;
      watchers = this.watchers;
      data = [];
      for (_i = 0, _len = watchers.length; _i < _len; _i++) {
        watcher = watchers[_i];
        data.push(watcher.toJSON());
      }
      return data;
    };

    Project.prototype.update = function() {
      return this.read(this.connect);
    };

    Project.prototype.connect = function() {
      return this.broadcast("watch", {
        body: this.toJSON()
      });
    };

    Project.prototype.broadcast = function(action, data, callback) {
      if (data.action === "initialize") {
        if (callback) callback.call(this, null, null);
        return;
      }
      data.namespace || (data.namespace = this.namespace);
      data = JSON.stringify(data, this.replacer);
      return this.hook.emit(action, data);
    };

    Project.prototype.log = function(data) {
      var action, path, timestamp, watcher, watchers, _i, _len, _results;
      watchers = this.watchers;
      path = data.path;
      action = data.action;
      timestamp = data.timestamp;
      _results = [];
      for (_i = 0, _len = watchers.length; _i < _len; _i++) {
        watcher = watchers[_i];
        if (watcher.hasOwnProperty("server") && watcher.server.hasOwnProperty(action) && watcher.id === data.id) {
          server.watcher = watcher;
          server.path = path;
          server.action = action;
          server.timestamp = timestamp;
          try {
            _results.push(!!server[action](data));
          } catch (error) {
            _results.push(console.log(error.stack));
          }
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Project.Watchfile = (function() {

      function Watchfile() {
        Watcher._store = void 0;
      }

      Watchfile.prototype.ignorePaths = function() {
        Project.ignoredPaths || (Project.ignoredPaths = []);
        return Project.ignoredPaths = Project.ignoredPaths.concat(Array.prototype.slice.call(arguments, 0, arguments.length));
      };

      Watchfile.prototype.watch = function() {
        return Project.createWatcher.apply(Project, arguments);
      };

      return Watchfile;

    })();

    return Project;

  })();

  module.exports = Project;

}).call(this);
