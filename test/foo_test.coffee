request = require("supertest")

app = require("../src/server")
describe "something", ->
  it "something", (done) ->
    request(app)
      .get("/foos")
      .expect(203)
      .end (err, res) ->
        console.log("err", err)
        done()
