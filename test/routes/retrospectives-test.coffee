redisClient = require('redis').createClient()
Retrospective = require("../../app/models").Retrospective
routes = require "../../app/routes/retrospectives"
require "should"

describe "retrospectives", ->
  req =
    params: {}
    body: {}
  res =
    redirect: (route) ->
    render: (view, vars) ->

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
    it "should create a retrospective then redirect", (done) ->
      retrospectiveName = "Created retro"
      req.params.retrospective = {}
      req.params.retrospective.name = retrospectiveName
      res.redirect = (route) ->
        route.should.equal "/retrospectives"

        Retrospective.find (err, ids) ->
          ids.should.have.length 1
          retrospectiveId = ids[0]
          new Retrospective.load retrospectiveId, (err, properties) ->
            properties.name.should.equal retrospectiveName
            done()

      redisClient.flushdb()
      routes.create(req, res)


