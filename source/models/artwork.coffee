class App.Models.Artwork extends Backbone.Model
  defaults:
    icon: ''
    'icon-500': ''
    'icon-1200': ''
    colors:
      0: "255,255,255"
      1: "255,255,255"
      2: "255,255,255"
      background: "0,0,0"
      contrast: "255,255,255"

  colors: -> @get('colors')

  initialize: ->
    @set('icon-200', @get('icon'))

    @compute 'icon-500', ->
      @get('icon-200').replace("square-200", "square-500")

    @compute 'icon-1200', ->
      @get('icon-200').replace("square-200", "square-1200")

    # if devicePixelRatio > 1
    #   @set('icon', @get('icon-1200')) 
    # else
    @set('icon', @get('icon-500')) 
    @analyze()

  blur: (callback) ->
    unless @get('icon')
      @once 'change:icon', @blur(callback)

    if @get('blurUrl')
      callback?(@get('blurUrl'))
      return this

    src    = @get('icon')
    canvas = document.createElement('canvas')
    img    = new Image()

    img.crossOrigin = "anonymous" unless /^data:/.test(src)

    img.onload = =>
      w = img.width
      h = img.height
      canvas.height = h
      canvas.width  = w
      canvas.getContext('2d').drawImage(img, 0, 0, w, h)
      stackBlurCanvasRGB(canvas, 0, 0, w, h, w / 10 << 0)

      @set('blurUrl', canvas.toDataURL())

      callback?(@get('blurUrl'))

    img.src = src
    this

  analyze: ->
    if colors = App.store.get('colors', {})[@get('icon-200')]
      return @set {colors}

    Chloroform.analyze @get('icon-200'), (colors) =>
      @set 'colors', colors

      stored_colors = App.store.get('colors', {})
      stored_colors[@get('icon-200')] = colors
      App.store.set 'colors', stored_colors
