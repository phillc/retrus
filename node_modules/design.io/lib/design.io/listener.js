(function() {
  var File, Listener, Pathfinder, _path;

  _path = require('path');

  Pathfinder = require('pathfinder');

  File = Pathfinder.File;

  Listener = (function() {

    function Listener(options, callback) {
      var directories, files, initialized, path, paths, self, source, stat, _i, _len;
      this.root = options.root;
      this.ignored = options.ignore || [];
      this.directories = directories = {};
      this.files = files = {};
      paths = File.glob(this.root);
      self = this;
      initialized = [];
      for (_i = 0, _len = paths.length; _i < _len; _i++) {
        source = paths[_i];
        if (!File.exists(source)) continue;
        stat = File.stat(source);
        path = _path.join(root, source.replace(root, ""));
        if (!stat.isDirectory()) {
          files[path] = stat;
          initialized.push(File.relativePath(path));
        } else {
          directories[path] = File.entries(path);
        }
      }
      try {
        callback.call(self, initialized, {
          action: "initialize"
        });
      } catch (error) {
        console.log(error.stack);
      }
    }

    Listener.prototype.ignore = function(path) {
      var ignoredPath, _i, _len, _ref;
      _ref = this.ignored;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        ignoredPath = _ref[_i];
        if (path.indexOf(ignoredPath) === 0) return true;
      }
      return false;
    };

    Listener.prototype.changed = function(path, callback) {
      var absolutePath, action, base, changed, current, deleted, directories, entries, entry, files, previous, relativePath, timestamp, _i, _len, _results;
      entries = File.entries(path);
      action = null;
      timestamp = new Date;
      directories = this.directories;
      files = this.files;
      base = this.root;
      if (this.ignore(path)) return;
      if (directories[path] && entries.length < directories[path].length) {
        directories = this.directories;
        action = "destroy";
        deleted = directories[path].filter(function(i) {
          return !(entries.indexOf(i) > -1);
        });
        directories[path] = entries;
        relativePath = File.join(path, deleted[0]).replace(base + '/', '');
        this.log(relativePath, {
          action: action,
          timestamp: timestamp
        }, callback);
        return;
      }
      directories[path] = entries;
      _results = [];
      for (_i = 0, _len = entries.length; _i < _len; _i++) {
        entry = entries[_i];
        if (entry === '.' || entry === '..') continue;
        absolutePath = File.join(path, entry);
        current = File.stat(absolutePath);
        if (current.isDirectory()) continue;
        previous = files[absolutePath];
        changed = !(previous && current.size === previous.size && current.mtime.getTime() === previous.mtime.getTime());
        if (!changed) continue;
        files[absolutePath] = current;
        if (!previous) {
          action || (action = "create");
        } else {
          action || (action = "update");
        }
        relativePath = absolutePath.replace(base.toString() + '/', '');
        _results.push(this.log(relativePath, {
          action: action,
          timestamp: timestamp,
          previous: previous,
          current: current
        }, callback));
      }
      return _results;
    };

    Listener.prototype.log = function(path, options, callback) {
      var name;
      if (options == null) options = {};
      name = options.action === "destroy" ? "deleted" : "" + options.action + "d";
      _console.info("" + name + " " + path);
      try {
        return callback.call(this, path, options);
      } catch (error) {
        return console.log(error.stack);
      }
    };

    return Listener;

  })();

  require('./listener/mac');

  require('./listener/polling');

  require('./listener/windows');

  module.exports = Listener;

}).call(this);
