nohm = require('nohm').Nohm

redisClient = require('redis').createClient()
nohm.setClient(redisClient)
nohm.setPrefix('retrus')

require "should"
Retrospective = require("../../models").Retrospective

describe "Retrospective", ->
  validAttributes =
    name: "Retro name"

  it "should save", (done) ->
    retrospective = new Retrospective
    retrospective.property
      name: "Awesome"
    console.log "and going..\n"
    # console.log "save ", retrospective.save
    retrospective.save (err) ->
      console.log("oops, fail. ", err)

      Retrospective.find (err, ids) ->
        console.log "ids", ids
        done()
