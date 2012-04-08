jade = require "jade"
jsdom = require "jsdom"
fs = require "fs"
should = require "should"

view = (path) ->
  __dirname + '/../../app/views/' + path + '.jade'

render = (path, vars, callbackfn) ->
  vars.title ?= "Default title"
  vars.pretty = true

  jade.renderFile view(path), vars, (errors, html) ->
    should.not.exist errors
    jsdom.env
      html: html
      scripts: []
      done: (errors, window) ->
        should.not.exist errors
        callbackfn window.$

describe "view retrospectives", ->
  describe "index", ->
    it "should list something", (done) ->
      vars = { retrospectives: [{}] }

      render "retrospectives/index", vars, ($) ->
        # window.$("retrospectives").length.should.be 2
        done()

