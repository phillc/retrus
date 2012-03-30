nohm = require('nohm').Nohm

redisClient = require('redis').createClient()
nohm.setClient(redisClient)
nohm.setPrefix('retrus')

should = require "should"
Retrospective = require("../../app/models").Retrospective

describe "Retrospective", ->
  before ->
    redisClient.flushdb()

  beforeEach ->
    @validAttributes =
      name: "Retro name"

  describe "name", ->
    it "should be saved", (done) ->
      retrospective = new Retrospective

      name = "Awesome"
      @validAttributes.name = name
      retrospective.property @validAttributes

      retrospective.save (err) ->
        should.not.exist(err)

        new Retrospective.load retrospective.id, (err, properties) ->
          should.not.exist(err)
          properties.name.should.equal name
          done()

    it "should be required", (done) ->
      retrospective = new Retrospective

      @validAttributes.name = ""
      retrospective.property @validAttributes

      retrospective.save (err) ->
        should.exist(err)
        retrospective.errors.name.should.eql [ "notEmpty" ]
        done()

  describe "private", ->
    it "should default to false", (done) ->
      retrospective = new Retrospective

      retrospective.property @validAttributes

      retrospective.save (err) ->
        should.not.exist(err)
        retrospective.property("private").should.be.false
        done()



