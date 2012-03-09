(function() {
  var Watcher, agents, app, broadcast, coffee, connect, designer, express, io, jade, testSocket;
  io = require('socket.io');
  express = require("express");
  connect = require('connect');
  Watcher = require("../../lib/design.io/watcher");
  Watcher.initialize({
    watchfile: "Watchfile",
    directory: process.cwd(),
    port: 4181,
    url: "http://localhost:4181"
  });
  app = express.createServer();
  coffee = require('coffee-script');
  designer = require('../../lib/design.io/connection')(require('socket.io').listen(app));
  app.listen(4181);
  jade = require("jade");
  app.use(express.static(__dirname + '/../..'));
  app.use(connect.bodyParser());
  app.set('view engine', 'jade');
  app.set('views', __dirname + '/views');
  app.get('/', function(request, response) {
    return response.render('index.jade', {
      title: 'Spec Runner',
      address: app.settings.address,
      port: app.settings.port,
      pretty: true
    });
  });
  app.post('/design.io/:event', function(request, response) {
    broadcast(request.params.event, JSON.stringify(request.body));
    return response.send(request.params.event);
  });
  testSocket = null;
  agents = {};
  broadcast = function(name, data) {
    return designer.emit(name, data);
  };
}).call(this);
