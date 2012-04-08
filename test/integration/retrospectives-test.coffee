request = require "../support/http"
app = require "../../app"

describe "integration retrospectives", ->
  describe "index", ->
    it "should display index with no retrospectives", (done) ->
      request(app).
        get("/").
        end (res) ->
          res.should.have.status 200
          done()

  describe "show", ->
    it "should display with no problems", (done) ->
      request(app).
        get("/retrospectives/1").
        end (res) ->
          res.should.have.status 200
          done()

  describe "show for facilitators", ->
    it "should display with no problems", (done) ->
      request(app).
        get("/retrospectives/1/facilitator").
        end (res) ->
          res.should.have.status 200
          done()
