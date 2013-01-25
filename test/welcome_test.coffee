request = require("supertest")
server = require("../src/server")

describe "welcome", ->
  it "renders", (done) ->
    request(server)
      .get("/")
      .expect(200, done)
