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
  socket.on 'sections:read', (data, callback) ->
    callback null, sections

  socket.on 'note:create', (data) -> console.log("got a foo", data)

tmpId = ->
  Math.floor(Math.random() * 10000)

sections = [ { id: tmpId(), name: "What went well", color: "#ffccaa" },
             { id: tmpId(), name: "What sucked", color: "#eeff00" }]

getSections = ->
  sections
  
