request = require "../support/http"
app = require "../../app"

describe "retrospectives", ->
  describe "index", ->
    it "should display index with no retrospectives", (done) ->
      request(app())
