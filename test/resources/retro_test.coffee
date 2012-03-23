http = require("../support/http")

describe "retrospectives#index", ->
  it "should render successfully", (done) ->
    http.request "/retrospectives", (res) ->
      res.statusCode.should.equal(200)
      done()

describe "retrospectives#create", ->
  it "redirect to the retrospective", (done) ->
    http.request "/retrospectives", (res) ->
      res.statusCode.should.equal(302)
      done()

