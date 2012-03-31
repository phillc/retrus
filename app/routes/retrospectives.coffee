exports.index = (req, res) ->
  res.render "retrospectives/index",
    title: "Retrospectives"
    retrospectives: []

exports.new = (req, res) ->
  res.render "retrospectives/new"

exports.create = (req, res) ->
  res.redirect "/retrospectives"

