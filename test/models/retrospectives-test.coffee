should = require "should"
Retrospective = require("../../models").Retrospective

describe "model Retrospective", ->
  beforeEach ->
    @validAttributes =
      name: "Retro name"

  describe "name", ->
    it "should be saved", (done) ->
      name = "Awesome"
      @validAttributes.name = name
      retrospective = new Retrospective @validAttributes

      retrospective.save (err) ->
        should.not.exist(err)

        Retrospective.findById retrospective._id, (err, doc) ->
          should.not.exist(err)
          doc.name.should.equal name
          done()

    it "should be required", (done) ->
      @validAttributes.name = ""
      retrospective = new Retrospective @validAttributes

      retrospective.save (err) ->
        should.exist(err)
        err.errors.name.type.should.eql "presence"
        done()

  describe "private", ->
    it "should default to false", (done) ->
      retrospective = new Retrospective @validAttributes
      retrospective.save (err) ->
        should.not.exist(err)
        retrospective.private.should.be.false
        done()



