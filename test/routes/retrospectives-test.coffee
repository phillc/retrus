Retrospective = require("../../models").Retrospective
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
    Retrospective.collection.drop()

  describe "index", ->
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

      retrospective = new Retrospective name: "foo"
      retrospective.save (err) ->
        should.not.exist(err)
        res.render = (view, vars) ->
          vars.retrospectives.should.have.length 1
          vars.retrospectives[0].name.should.eql "foo"
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
        Retrospective.findOne (err, doc) ->
          should.not.exist(err)
          route.should.equal "/retrospectives/" + doc._id + "/facilitator"
          doc.name.should.equal retrospectiveName
          done()

      routes.create(@req, @res)

    it "should render new on errors", (done) ->
      @res.render = (view, vars) ->
        view.should.equal "retrospectives/new"
        vars.errors.errors.name.type.should.eql "required"

        Retrospective.findOne (err, doc) ->
          should.not.exist(err)
          done()

      routes.create(@req, @res)


