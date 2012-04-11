app = require "../../app"
Browser = require "zombie"
server = app.listen 4001
require("socketstream").start server
assert = require "assert"

describe "entering the retrospective", ->
  it "does something", (done) ->
    browser = new Browser()
    browser.visit "http://localhost:4001", ->
      assert.ok browser.success
      done()

