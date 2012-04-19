# Retrospective = require("../../models").Retrospective
exports.index = (req, res) ->
  Retrospective.find (err, docs) ->
    res.render "retrospectives/index",
      title: "Retrospectives"
      retrospectives: docs

exports.new = (req, res) ->
  res.render "retrospectives/new"

exports.create = (req, res) ->
  retrospective = new Retrospective
    name: req.body.retrospective?.name
    private: req.body.retrospective?.private

  retrospective.save (err) ->
    if err
      res.render "retrospectives/new", { errors: err }
    else
      res.redirect "/retrospectives/" + retrospective.id + "/facilitator"

