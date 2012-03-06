exports.index = (req, res) ->
  res.render "retrospectives/index"

exports.create = (req, res) ->
  id = 1
  res.redirect('/retro/' + id + '/director')
  # res.render 'retro/create'
