http = require("../support/http")

describe "retro#index", ->
  it "should do something...", (done) ->
    http.request "/", (res) ->
      res.statusCode.should.equal(200)
      done()

