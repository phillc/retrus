(function() {
  var Mac;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  Mac = (function() {

    __extends(Mac, require('../listener'));

    function Mac(options, callback) {
      var child, forever;
      var _this = this;
      Mac.__super__.constructor.apply(this, arguments);
      forever = require("forever");
      child = forever.start(["ruby", "" + __dirname + "/mac.rb", this.root.replace(" ", "\\ ")], {
        max: 10,
        silent: true
      });
      child.on("stdout", function(data) {
        var path, _i, _len, _results;
        data = data.toString().trim();
        try {
          data = JSON.parse("[" + data.replace(/\]\[/g, ",").replace(/[\[\]]/g, "") + "]");
          _results = [];
          for (_i = 0, _len = data.length; _i < _len; _i++) {
            path = data[_i];
            _results.push(_this.changed(path.slice(0, -1), callback));
          }
          return _results;
        } catch (error) {
          return _console.error(error.toString());
        }
      });
      child.on("stderr", function(data) {
        return _console.error(data.toString().trim());
      });
      forever.startServer(child);
    }

    return Mac;

  })();

  module.exports = Mac;

}).call(this);
