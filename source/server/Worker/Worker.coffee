http    = require 'http'
Request = require '../Request/Request'
cluster = require 'cluster'

options = process.env

address = options.address or 'localhost'
port    = options.port    or 4321
socket  = options.socket  or null

server = http.createServer (request, response) ->
  new Request(request, response)

if socket
  console.log "Listening to #{socket}."
  server.listen(socket)
else
  console.log "Listening on port #{port} at #{address}."
  server.listen(port, address)
