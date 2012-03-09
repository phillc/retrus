(function() {
  var Hook, Project, app, command, connect, express, hook, io;

  command = require(__dirname)(process.argv);

  Hook = require("hook.io").Hook;

  io = require('socket.io');

  express = require("express");

  connect = require('connect');

  app = express.createServer();

  io = require('socket.io').listen(app);

  Project = require("../project");

  io.set('log level', 2);

  io.sockets.on("connection", function(socket) {
    socket.on("userAgent", function(data) {
      socket.room = data.namespace;
      socket.join(data.namespace);
      return socket.set("userAgent", data, function() {
        var _this = this;
        hook.emit("connect", function() {});
        return true;
      });
    });
    socket.on("log", function(data) {
      Project.find(data.namespace).log(data);
      return true;
    });
    return socket.on("disconnect", function() {
      socket.emit("user disconnected");
      return socket.leave(socket.room);
    });
  });

  app.listen(command.port);

  app.use(express.static(__dirname + '/../..'));

  app.use(connect.bodyParser());

  hook = new Hook({
    name: "design.io-server",
    debug: true,
    silent: false,
    m: false
  });

  hook.on("hook::ready", function(data, callback, event) {
    return _console.info("Design.io started on port " + command.port);
  });

  hook.on("*::*::ready", function(data, callback, event) {});

  hook.on("*::*::watch", function(data, callback, event) {
    var object;
    if (!event.name.match("design.io-watcher")) return;
    object = JSON.parse(data);
    return io.sockets["in"](object.namespace).emit("watch", data);
  });

  hook.on("*::*::exec", function(data, callback, event) {
    var object;
    if (!event.name.match("design.io-watcher")) return;
    object = JSON.parse(data);
    return io.sockets["in"](object.namespace).emit("exec", data);
  });

  hook.start();

  app.get("/design.io", function(request, response) {
    return response.write("Design.io Connected!");
  });

}).call(this);
