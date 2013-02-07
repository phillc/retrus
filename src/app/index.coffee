derby = require 'derby'
{get, view, ready} = derby.createApp module
derby.use(require '../../ui')


## ROUTES ##

start = +new Date()

# Derby routes can be rendered on the client and the server
get '/', (page, model, {roomName}) ->
  page.render('home')

## CONTROLLER FUNCTIONS ##

ready (model) ->
  $("#landingCarousel").carousel("cycle")
