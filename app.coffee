ss = require("socketstream")

connect = require("connect")
express = require("express")

app = module.exports = express()

app.configure ->
  app.set "views", __dirname + "/app/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use connect.logger()
  app.use app.router
  app.use ss.http.middleware
  app.locals.pretty = true

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", require("./app/routes/index").index

retrospectivesRoute = require("./app/routes/retrospectives")
app.get "/retrospectives", retrospectivesRoute.index
app.get "/retrospectives/new", retrospectivesRoute.new
app.post "/retrospectives", retrospectivesRoute.create

app.get "/retrospectives/:id/facilitator", (req, res) ->
  res.serveClient "retrospective"

app.get "/retrospectives/:id", (req, res) ->
  res.serveClient "retrospective"

ss.client.define "retrospective",
  view: "retrospective.jade"
  css: [ "retrospective.styl" ]
  code: [ "libs" ]
  tmpl: [ "restrospective" ]

###### for reference
app.get "/chat", (req, res) ->
  res.serveClient "main"

ss.client.define "main",
  view: "app.jade"
  css: [ "libs", "app.styl" ]
  code: [ "libs", "app" ]
  tmpl: "*"
######

ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-jade")
ss.client.formatters.add require("ss-stylus")
ss.client.templateEngine.use require("ss-hogan")
ss.client.packAssets() if ss.env is "production"

if !module.parent
  server = app.listen 4000
  console.log "Express server listening on port 4000"
  ss.start server
  console.log "Socket stream started"

