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

