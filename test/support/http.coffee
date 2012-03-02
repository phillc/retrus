app = require('../../app')
http = require('http')

testPort = 3001

app.listen(testPort)

module.exports.request = (path, cb) ->
  http.request({ path: path, port: testPort }).on('response', (res) ->
    res.body = ''
    res.on 'data', (chunk) ->
      res.body += chunk
    res.on 'end', ->
      cb(res)
  ).end()
