url    = require 'url'
path   = require 'path'
http   = require 'http'
glob   = require 'glob'
fs     = require 'fs'
stylus = require 'stylus'
coffee = require 'coffee-script'
hamlc  = require 'haml-coffee'
eco    = require 'eco'
_      = require 'underscore'

nop = ->

class File
  constructor: (p...) ->
    p     = path.join(p...).replace(/^\/|\/$/g, '')
    ext   = path.extname(p) or '.html'

    @dir  = path.dirname(p)
    @name = path.basename(p, ext) or 'index'
    @path = path.join(@dir, @name) + ext
    @compact = _.last(@dir.match(/(\/views\/)(.*)/)) or @dir
    @ext  = ext.slice(1)

  exists: (options = {}) ->
    success = options.success or options.yes or nop
    error   = options.error   or options.no  or nop

    fs.exists @path, (exists) =>
      if exists then success(this) else error(this)

  withPrefix: (p...) ->
    new File(p..., @path)

  withExt: (ext) ->
    new File(path.join(@dir, @name) + '.' + ext)

  find: (options = {}) ->
    success = options.success or nop
    error   = options.error   or nop

    @exists
      yes: =>
        @read options
      no: =>
        @withExt(File.extensions[@ext]).exists
          yes: (file) => file.find options
          no: error

  read: (options = {}) ->
    success = options.success or nop
    error   = options.error   or nop

    fs.readFile @path, (err, data) =>
      if err
        error(this, err)
      else
        @contents = data.toString()
        success this

File.glob = (path, options = {}) ->
  success = options.success or nop
  error   = options.error   or nop

  glob path, {}, (err, files) ->
    if err
      error(err)
    else
      success files.map (p) ->
        new File(p)

File.extensions =
  js:    'coffee'
  html:  'hamlc'
  jst:   'hamlc'
  hamlc: 'eco'
  css:   'styl'

class Request
  constructor: (@request, @response) ->
    _.bindAll this, 'route', 'error', 'compile', 'end',
      'status', 'e', 'contentType', 'notFound', 'log'

    @file = new File(url.parse(@request.url).pathname)

    @log()
    @route()

  mimes:
    js:   'application/javascript'
    jst:  'application/javascript'
    html: 'text/html'
    css:  'text/css'
    svg:  'image/svg+xml'
    eot:  'application/vnd.ms-fontobject'
    otf:  'application/octet-stream'
    ttf:  'application/octet-stream'

  compilers:
    js:
      js: (file, done) ->
        done.call this, file.contents
      coffee: (file, done) ->
        done.call this, coffee.compile(file.contents)

    jst:
      jst: (file, done) ->
        done.call this, file.contents
      hamlc: (file, done) ->
        done.call this, hamlc.template(file.contents, file.compact)
      eco: (file, done) ->
        done.call this, eco.compile(file.contents)

    html:
      html: (file, done) ->
        done.call this, file.contents
      hamlc: (file, done) ->
        done.call this, hamlc.render(file.contents)
      eco: (file, done) ->
        done.call this, eco.render(file.contents)

    css:
      css:  (file, done) ->
        done.call this, file.contents
      styl: (file, done) ->
        stylus.render file.contents, filename: file.path, (err, css) =>
          unless @error(err)
            done.call this, css

  route: ->
    @file.withPrefix('static').exists
      yes: (file) =>
        file.read error: @error, success: (file) =>
          @contentType @mimes[@file.ext]
          @end(file.contents)
      no: =>
        @file.withPrefix('source').find
          error: @notFound
          success: (file) =>
            @compile file, (text) =>
              @contentType @mimes[@file.ext]
              @end(text)

  end: (str) ->
    @response.end(str)

  status: (code = 200) ->
    @response.statusCode = code

  log: ->
    console.log @request.method, @request.url

  contentType: (type) ->
    @response.setHeader "Content-Type", type

  notFound: ->
    @status 404
    @end "Could not find '#{@file.path}'"

  e: (fn) ->
    return (args...) ->
      try
        fn.apply this, args
      catch e
        @error e
        return true
      return false

  error: (e) ->
    if e
      switch e.code
        when 'ENOENT'
          @notFound()
        else
          console.log e
          @status 500
          @response.end(e.toString())
      return e

  compile: (file, done) ->
    if compiler = @compilers[@file.ext]?[file.ext]

      compiler.call this, file, done
    else
      done.call this, file.contents

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
