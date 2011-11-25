var express = require('express')
  , app = express.createServer()
  , io = require('socket.io').listen(app);

app.listen(3000);
app.set('view engine', 'jade');
app.use(express.static(__dirname + '/public'));

app.configure('development', function() {
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function() {
  app.use(express.errorHandler());
});

app.get('/', function (req, res) {
  res.render('index');
});

io.sockets.on('connection', function (socket) {
  socket.emit("addSection", [{ name: "What went well"}, { name: "What sucked" }])
  socket.on("notes:create", function(){ console.log("got a foo")})
});
