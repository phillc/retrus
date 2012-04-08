Retrospective = require("../../app/models").Retrospective
exports.index = (req, res) ->
  allRetrospectives = (callbackfn) ->
    Retrospective.find (err, ids) ->
      idsLength = ids.length
      retrospectives = []

      if idsLength == 0
        callbackfn retrospectives
      else
        counted = 0
        ids.forEach (id) ->
          retrospective = new Retrospective
          retrospective.load id, (err, props) ->
            retrospectives.push retrospective

            if ++counted == idsLength
              callbackfn retrospectives


  allRetrospectives (retrospectives) ->
    res.render "retrospectives/index",
      title: "Retrospectives"
      retrospectives: retrospectives

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
      res.render "retrospectives/new", { errors: errors }
    else
      res.redirect "/retrospectives/" + retrospective.id + "/facilitator"

