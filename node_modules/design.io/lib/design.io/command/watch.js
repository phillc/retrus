(function() {
  var command, project;

  command = require(__dirname)(process.argv);

  project = require("../project");

  project = new project(command);

  project.watch();

}).call(this);
