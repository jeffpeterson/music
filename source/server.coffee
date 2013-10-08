http   = require 'http'
fs     = require 'fs'
stylus = require 'stylus'
coffee = require 'coffee-script'
hamlc  = require 'haml-coffee'

class Request
  constructor: (@request, @response) ->
    @log()
    @route()

  route: ->
    [match, filename, extension] = @request.url.match(/^\/([^.]+)\.?([a-z]+)?$/i)

    filename  or= 'index'
    extension or= 'html'

    @compile filename, extension, (text) ->
      @end(text)

  end: (str) ->
    @response.end(str)

  status: (code = 200) ->
    @response.statusCode = code

  log: ->
    console.log @request.method, @request.url

  readFile: (filename, done) ->
    base = './source/'
    fs.readFile base + filename, (err, data) =>
      unless @error(err)
        done.call this, data.toString()

  contentType: (type) ->
    @response.setHeader "Content-Type", type

  error: (e) ->
    if e
      console.log e
      @status 500
      @response.end(e.toString())
      return e

  compile: (filename, extension, done) ->
    switch extension
      when 'css'
        @readFile filename + '.styl', (text) ->
          stylus.render text, {filename}, (err, css) =>
            done.call this, css

      when 'js'
        @readFile filename + '.coffee', (text) ->
          done.call this, coffee.compile(text)

      when 'html'
        @readFile filename + '.hamlc', (text) ->
          done.call this, hamlc.template(text)

      else
        @readFile filename + '.' + extension, (text) ->
          done.call this,  text

exports.serve = (options) ->
  port    = options.on or 4321
  address = options.at or 'localhost'
  socket  = options.to

  server = http.createServer (request, response) ->
    new Request(request, response)

  if socket
    console.log "Listening to #{socket}."
    server.listen(socket)
  else
    console.log "Listening on port #{port} at #{address}."
    server.listen(port, address)

