derby = require 'derby'
{get, view, ready} = derby.createApp module
derby.use(require '../../ui')


## ROUTES ##

start = +new Date()

# Derby routes can be rendered on the client and the server
get '/', (page, model, {roomName}) ->
  page.render()


## CONTROLLER FUNCTIONS ##

ready (model) ->
  timer = null

  # Functions on the app can be bound to DOM events using the "x-bind"
  # attribute in a template.
  @stop = ->
    # Any path name that starts with an underscore is private to the current
    # client. Nothing set under a private path is synced back to the server.
    model.set '_stopped', true
    clearInterval timer

  do @start = ->
    model.set '_stopped', false
    timer = setInterval ->
      model.set '_timer', (((+new Date()) - start) / 1000).toFixed(1)
    , 100
