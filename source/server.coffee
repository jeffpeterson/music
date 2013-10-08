http = require 'http'

server = http.createServer (request, response) ->

status = (response, code = 200) ->
  response.statusCode = code

log = (request) ->
  console.log request.method, request.url

exports.serve = (options) ->

  server = http.createServer (request, response) ->
    log request
    switch request.url
      when '/'
        status response, 200
        response.end("test")
      else
        status response, 404
        response.end('Not found')

  console.log "Listening on port #{port} at #{bind}."
  server.listen(port, bind)

