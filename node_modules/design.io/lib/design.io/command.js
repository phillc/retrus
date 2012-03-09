(function() {
  var command, forever, fs;

  global._console || (global._console = require("underscore.logger"));

  fs = require('fs');

  forever = require("forever");

  command = function(argv) {
    var program, slug, version;
    program = require("commander");
    version = JSON.parse(fs.readFileSync(__dirname + "/../../package.json", "utf-8")).version;
    program.version(version).option("-d, --directory [value]", "directory to watch files from").option("-w, --watchfile [value]", "location of Watchfile").option("-p, --port <n>", "port for the socket connection").option("--debug", "Debug?").option("-u, --url [value]", "URL for the socket connection").option("-i, --interval <n>", "interval (in milliseconds) files should be scanned (only useful if you can't use FSEvents).  Not implemented").option("-n, --namespace [value]", "Namespace for the project").option("--growl", "Namespace for the project").parse(process.argv);
    program.directory || (program.directory = process.cwd());
    program.watchfile || (program.watchfile = "Watchfile");
    program.port = program.port ? parseInt(program.port) : process.env.PORT || 4181;
    program.url || (program.url = "http://localhost:" + program.port);
    program.command = program.args[0] || "watch";
    program.root = process.cwd();
    program.growl = !!program.growl;
    if (!program.namespace) {
      slug = process.cwd().split("/");
      slug = slug[slug.length - 1];
      slug = slug.replace(/\.[^\.]+$/, "");
      program.namespace = slug;
    }
    return program;
  };

  command.run = function(argv) {
    var args, child, program;
    program = command(argv);
    args = argv.concat().slice(2);
    child = (function() {
      switch (program.command) {
        case "start":
          return forever.start(["node", "" + __dirname + "/command/start.js"].concat(args), {
            silent: false,
            max: 1
          });
        case "stop":
          return forever.start(["node", "" + __dirname + "/command/stop.js"].concat(args), {
            silent: true,
            max: 1
          });
        default:
          return forever.start(["node", "" + (process.cwd()) + "/node_modules/design.io/lib/design.io/command/watch.js"].concat(args), {
            silent: false
          });
      }
    })();
    child.on("start", function(data) {
      return console.log(data);
    });
    child.on("exit", function() {});
    child.on("stop", function() {});
    child.on("stdout", function(data) {});
    child.on("stderr", function(error) {
      return console.log(error.toString());
    });
    child.on("error", function() {});
    forever.startServer(child);
    return program;
  };

  module.exports = command;

}).call(this);
