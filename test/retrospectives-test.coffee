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
    it "should display index with no retrospectives", (done) ->
      res.render = (view, vars) ->
        view.should.equal "retrospectives/index"
        vars.title.should.equal "Retrospectives"
        vars.retrospectives.should.eql []
        done()
      routes.index(req, res)
  describe "new", ->
    it "should display new", (done) ->
      res.render = (view, vars) ->
        view.should.equal "retrospectives/new"
        done()
      routes.new(req, res)
  describe "create", ->
    it "should create a retrospective", (done) ->
      routes.create(req, res)


