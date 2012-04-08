redisClient = require('redis').createClient()
Retrospective = require("../../app/models").Retrospective
routes = require "../../app/routes/retrospectives"
should = require "should"

describe "route retrospectives", ->
  beforeEach ->
    @req =
      params: {}
      body: {}
    @res =
      redirect: (route) ->
      render: (view, vars) ->

  describe "index", ->
    beforeEach ->
      redisClient.flushdb()

    it "should display index with no retrospectives", (done) ->
      @res.render = (view, vars) ->
        view.should.equal "retrospectives/index"
        vars.title.should.equal "Retrospectives"
        vars.retrospectives.should.eql []
        done()
      routes.index(@req, @res)

    it "should display index with retrospectives", (done) ->
      res = @res
      req = @req

      retrospective = new Retrospective
      retrospective.property(name: "foo")
      retrospective.save (err) ->
        should.not.exist(err)
        res.render = (view, vars) ->
          vars.retrospectives.should.have.length 1
          vars.retrospectives[0].property("name").should.eql "foo"
          done()
        routes.index(req, res)

  describe "new", ->
    it "should display new", (done) ->
      @res.render = (view, vars) ->
        view.should.equal "retrospectives/new"
        done()
      routes.new(@req, @res)

  describe "create", ->
    it "should create a retrospective then redirect", (done) ->
      retrospectiveName = "Created retro"
      @req.body.retrospective = {}
      @req.body.retrospective.name = retrospectiveName
      @res.redirect = (route) ->
        route.should.equal "/retrospectives"

        Retrospective.find (err, ids) ->
          ids.should.have.length 1
          retrospectiveId = ids[0]
          new Retrospective.load retrospectiveId, (err, properties) ->
            properties.name.should.equal retrospectiveName
            done()

      redisClient.flushdb()
      routes.create(@req, @res)

    it "should render new on errors", (done) ->
      @res.render = (view, vars) ->
        view.should.equal "retrospectives/new"
        vars.should.eql errors: { name: ["notEmpty"] }

        Retrospective.find (err, ids) ->
          ids.should.have.length 0
          done()
      redisClient.flushdb()
      routes.create(@req, @res)


