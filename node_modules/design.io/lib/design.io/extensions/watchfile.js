
  module.exports = function() {
    var project;
    project = require("../project").find();
    return project.createWatcher(project.watchfile, {
      update: function() {
        return this.updateAll();
      },
      destroy: function() {
        return this.updateAll();
      }
    });
  };
