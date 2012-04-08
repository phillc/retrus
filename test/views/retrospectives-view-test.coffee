jade = require "jade"
jsdom = require "jsdom"
fs = require "fs"
should = require "should"
Retrospective = require("../../app/models").Retrospective

view = (path) ->
  __dirname + '/../../app/views/' + path + '.jade'

render = (path, vars, callbackfn) ->
  vars.title ?= "Default title"
  vars.pretty = true

  jade.renderFile view(path), vars, (errors, html) ->
    should.not.exist errors
    jsdom.env
      html: html
      scripts: [__dirname + '/../../client/static/js/jquery-1.7.2.js']
      done: (errors, window) ->
        should.not.exist errors
        callbackfn window.$

describe "view retrospectives", ->
  describe "index", ->
    it "should list something", (done) ->

      retrospective = new Retrospective
      retrospective.property
        name: "Foo bar"
      vars = { retrospectives: [retrospective] }

      render "retrospectives/index", vars, ($) ->
        $("#retrospectives-list li").length.should.eql(1)
        done()

