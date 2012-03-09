(function() {
  var File, Pathfinder, Project, Watcher, fs, path, uuid;
  var __slice = Array.prototype.slice;

  fs = require('fs');

  path = require('path');

  uuid = require('node-uuid');

  Pathfinder = require('pathfinder');

  Project = require('./project');

  File = Pathfinder.File;

  require('underscore.logger');

  Watcher = (function() {

    function Watcher() {
      var arg, args, key, methods, project, value, _i, _len;
      project = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      this.project = project;
      methods = args.pop();
      if (typeof methods === "function") methods = methods.call(this);
      if (args[0] instanceof Array) args = args[0];
      this.ignore = null;
      this.patterns = [];
      for (_i = 0, _len = args.length; _i < _len; _i++) {
        arg = args[_i];
        if (!arg) continue;
        this.patterns.push(typeof arg === "string" ? new RegExp(arg) : arg);
      }
      for (key in methods) {
        value = methods[key];
        this[key] = value;
      }
      this.id || (this.id = uuid());
      if (this.hasOwnProperty("server")) this.server.watcher = this;
    }

    Watcher.prototype.initialize = function(path, callback) {
      return callback();
    };

    Watcher.prototype.create = function(path, callback) {
      return this.update(path, callback);
    };

    Watcher.prototype.update = function(path, callback) {
      var _this = this;
      return fs.readFile(path, 'utf-8', function(error, result) {
        if (error) return _this.error(error);
        return _this.broadcast({
          body: result
        }, callback);
      });
    };

    Watcher.prototype.destroy = function(path, callback) {
      return this.broadcast(callback);
    };

    Watcher.prototype.updateAll = function() {
      return Watcher.update();
    };

    Watcher.prototype.error = function(error, callback) {
      if (this.action !== "initialize") console.log(error.stack || error);
      if (this.project.growl) {
        require("growl")(error.message, {
          title: this.project.namespace,
          sticky: false
        });
      }
      if (callback) callback();
      return false;
    };

    Watcher.prototype.match = function(path) {
      var pattern, patterns, _i, _len;
      if (this.ignore && !!this.ignore.exec(path)) return false;
      patterns = this.patterns;
      for (_i = 0, _len = patterns.length; _i < _len; _i++) {
        pattern = patterns[_i];
        if (!!pattern.exec(path)) return true;
      }
      return false;
    };

    Watcher.prototype.invoke = function(path, options, next) {
      var action, duration, timeout, timeoutError, timestamp, watcherCallback;
      var _this = this;
      action = options.action;
      timestamp = options.timestamp;
      duration = options.duration;
      if (this.match(path)) {
        this.path = path;
        this.action = action;
        this.timestamp = timestamp;
        watcherCallback = function(error) {
          clearTimeout(timeout);
          if (error) console.log(error.stack || error);
          return process.nextTick(next);
        };
        timeoutError = function() {
          return watcherCallback(new Error("Watcher for " + (_this.patterns.toString()) + " timed out.  Make sure you have and call a callback in each watcher method (e.g. update: function(path, callback))"));
        };
        timeout = setTimeout(timeoutError, duration);
        try {
          switch (this[action].length) {
            case 0:
            case 1:
              this[action].call(this, path);
              return watcherCallback();
            case 2:
              return this[action].call(this, path, watcherCallback);
            case 3:
              return this[action].call(this, path, options, watcherCallback);
          }
        } catch (error) {
          return watcherCallback(error);
        }
      } else {
        return next();
      }
    };

    Watcher.prototype.broadcast = function() {
      var action, args, callback, data;
      args = Array.prototype.slice.call(arguments, 0, arguments.length);
      callback = args.pop();
      if (typeof callback === "function") {
        data = args.pop() || {};
      } else {
        data = callback;
        callback = null;
      }
      data.action || (data.action = this.action);
      data.path || (data.path = this.path);
      data.id = this.id;
      data.timestamp = this.timestamp;
      data.namespace = this.project.namespace;
      action = args.shift() || "exec";
      return this.project.broadcast(action, data, callback);
    };

    Watcher.prototype.toJSON = function() {
      var client, data, key, value;
      data = {
        patterns: this.patterns,
        match: this.match,
        id: this.id
      };
      if (this.hasOwnProperty("client")) {
        client = this.client;
        for (key in client) {
          value = client[key];
          data[key] = value;
        }
      }
      return data;
    };

    return Watcher;

  })();

  module.exports = Watcher;

}).call(this);
