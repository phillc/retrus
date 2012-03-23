routes = require "../routes/retrospectives"
require "should"

describe "retrospectives", ->
  req =
    params: {}
    body: {}
  res =
    redirect: (route) ->
    render: (route) ->

  describe "index", ->
    it "should display index with retrospectives", (done)->
      res.render = (view, vars) ->
          view.should.equal "index"
          vars.title.should.equal "Retrospectives"
          done()
      routes.index(req, res)

