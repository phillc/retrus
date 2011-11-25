express = require('express')
app = express.createServer()
io = require('socket.io').listen(app)

app.listen(3000)
app.set('view engine', 'jade')
app.use(express.static(__dirname + '/public'))

app.configure 'development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))


app.configure 'production', ->
  app.use(express.errorHandler())

app.get '/', (req, res) ->
  res.render('index')

io.sockets.on 'connection', (socket) ->
  socket.emit "addSection", getSections()
  socket.on "notes:create", -> console.log("got a foo")


sections = [{ name: "What went well"}, { name: "What sucked" }]

getSections = ->
  sections