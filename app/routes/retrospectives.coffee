Retrospective = require("../../app/models").Retrospective
exports.index = (req, res) ->
  res.render "retrospectives/index",
    title: "Retrospectives"
    retrospectives: []

exports.new = (req, res) ->
  res.render "retrospectives/new"

exports.create = (req, res) ->
  retrospective = new Retrospective
  retrospective.property
    name: req.body.retrospective?.name
    private: req.body.retrospective?.private

  retrospective.save (err) ->
    if err
      errors = {}
      for property, values of retrospective.errors
        if values.length > 0
          errors[property] = values
      res.render "retrospectives/new", errors
    else
      res.redirect "/retrospectives"

