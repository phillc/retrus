ss = require("socketstream")

express = require("express")
require("express-resource")

app = module.exports = express.createServer()
routes = require("./routes")

app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", routes.index
app.resource "retrospectives", require("./routes/retrospectives")

ss.client.define "main",
  view: "app.jade"
  css: [ "libs", "app.styl" ]
  code: [ "libs", "app" ]
  tmpl: "*"

ss.http.route "/chat", (req, res) ->
  res.serveClient "main"

ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-jade")
ss.client.formatters.add require("ss-stylus")
ss.client.templateEngine.use require("ss-hogan")
ss.client.packAssets()  if ss.env is "production"

if !module.parent
  server = app.listen 3000
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
  ss.start server
  console.log "Socket stream started"

