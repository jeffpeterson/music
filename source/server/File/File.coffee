_      = require 'underscore'
fs      = require 'fs'
glob    = require 'glob'
path    = require 'path'

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

    # if contents = File.cache[@path]
    #   console.log 'reading', @path, 'from cache'
    #   @contents = contents
    #   success this
    #   return

    fs.readFile @path, (err, data) =>
      if err
        error(this, err)
      else
        @contents = data.toString()
        success this
        # File.cache[@path] = @contents

        # fs.watch @path, (event, filename) =>
        #   delete File.cache[@path]

File.glob = (path, options = {}) ->
  success = options.success or nop
  error   = options.error   or nop

  glob path, {}, (err, files) ->
    if err
      error(err)
    else
      success files.map (p) ->
        new File(p)

File.watchers = {}

File.cache = {}

File.extensions =
  js:    'coffee'
  html:  'hamlc'
  jst:   'hamlc'
  hamlc: 'eco'
  css:   'styl'

module.exports = File
