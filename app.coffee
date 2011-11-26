express = require('express')
app = express.createServer()
io = require('socket.io').listen(app)
mongoose = require('mongoose')
Schema = mongoose.Schema

mongoose.connect 'mongodb://localhost/retrus'

NoteSchema = new Schema({ text: String
                        , ups: Number
                        , downs: Number })

GroupSchema = new Schema({ name: String
                         , notes: [NoteSchema] })

SectionSchema = new Schema({ name: String
                           , color: String
                           , notes: [NoteSchema] })

RetroSchema = new Schema({ name: String
                         , sections: [SectionSchema] })

Note = mongoose.model 'Note', NoteSchema
Group = mongoose.model 'Group', GroupSchema
Section = mongoose.model 'Section', SectionSchema

Section.count {}, (err, size) ->
  if size == 0
    console.log("Creating default sections")
    new Section({ name: "What went well", color: "#ffccaa" }).save()
    new Section({ name: "What sucked", color: "#eeff00" }).save()

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
    Section.find {}, (err, docs) ->
      console.log("Sending sections:", docs)
      callback null, docs

  socket.on 'note:create', (data) -> console.log("got a foo", data)
