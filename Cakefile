fs = require 'fs'

option '-p', '--port NUMBER',     'port to listen on'
option '-a', '--address ADDRESS', 'address to listen at'
option '-S', '--socket PATH',     'unix socket to bind to'

task 'serve', 'serve the site for development', (options) ->
  require('./source/server/server.coffee').serve(on: options.port, at: options.address, to: options.socket)

task 'install', 'install requirements for development', (options) ->
  console.log "do something here"



