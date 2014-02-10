http       = require 'http'
Request    = require '../Request/Request'
cluster    = require 'cluster'
livereload = require 'livereload'

options = process.env

address = options.address or 'localhost'
port    = options.port    or 4321
socket  = options.socket  or null

livereloadServer = livereload.createServer
  exts: 'coffee js jst styl hamlc'.split(' ')
  applyCSSLive: true
  applyJSLive:  true

livereloadServer.watch(__dirname + "/../..")

server = http.createServer (request, response) ->
  new Request(request, response)

if socket
  console.log "Listening to #{socket}."
  server.listen(socket)
else
  console.log "Listening on port #{port} at #{address}."
  server.listen(port, address)
