_       = require 'underscore'
coffee  = require 'coffee-script'
eco     = require 'eco'
File    = require '../File/File'
hamlc   = require 'haml-coffee'
path    = require 'path'
stylus  = require 'stylus'
url     = require 'url'

nop = ->

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
        done.call this, hamlc.render(file.contents, path: path)
      eco: (file, done) ->
        done.call this, eco.render(file.contents)

    css:
      css:  (file, done) ->
        done.call this, file.contents
      styl: (file, done) ->
        stylus(file.contents)
          .set('filename', file.path)
          .import(path.resolve(__dirname, '../../views/app/vendor'))
          .render (err, css) =>
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

module.exports = Request
