http = require('http')
express = require('express')
app = express()
module.exports = app

app.use(express.static(__dirname + '/public', { 'keepAlive': false }))
app.get '/', (req, res)->
  res.sendFile __dirname + 'public/index.html'

if !module.parent
  http.createServer(app).listen 8080, ->
    console.log 'Server listening on port 8080'