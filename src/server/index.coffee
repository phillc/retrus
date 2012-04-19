path = require 'path'
express = require 'express'
derby = require 'derby'
gzip = require 'connect-gzip'
app = require '../app'


## SERVER CONFIGURATION ##

MAX_AGE_ONE_YEAR = maxAge: 1000 * 60 * 60 * 24 * 365
root = path.dirname path.dirname __dirname
publicPath = path.join root, 'public'
staticPages = derby.createStatic root

(module.exports = server = express.createServer())
  .use(gzip.staticGzip publicPath, MAX_AGE_ONE_YEAR)
  .use(express.favicon())
  .use(express.bodyParser())
  .use(express.methodOverride())

  # Uncomment and supply secret to add Derby session handling
  # Derby session middleware creates req.model and subscribes to _session
  # .use(express.cookieParser())
  # .use(express.session(secret: '', cookie: MAX_AGE_ONE_YEAR))
  # .use(app.session())

  .use(gzip.gzip())

  # The router method creates an express middleware from the app's routes
  .use(app.router())
  .use(server.router)

## ERROR HANDLING ##

server.configure 'development', ->
  # Log errors in development only
  server.error (err, req, res, next) ->
    if err then console.log(if err.stack then err.stack else err)
    next err

server.error (err, req, res) ->
  ## Customize error handling here ##
  message = err.message || err.toString()
  status = parseInt message
  if status is 404 then staticPages.render '404', res, {url: req.url}, 404
  else res.send if 400 <= status < 600 then status else 500


## SERVER ONLY ROUTES ##

server.get "/", require("./routes/index").index
retrospectivesRoute = require("./routes/retrospectives")
server.get "/retrospectives", retrospectivesRoute.index
server.get "/retrospectives/new", retrospectivesRoute.new
server.post "/retrospectives", retrospectivesRoute.create

server.all '*', (req) ->
  throw "404: #{req.url}"


## STORE SETUP ##

store = app.createStore listen: server
