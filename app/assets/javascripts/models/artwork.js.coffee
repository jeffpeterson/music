class App.Models.Artwork extends Backbone.Model
  defaults:
    icon: ''
    'icon-500': ''

    colors:
      background: "0,0,0"
      primary:    "255,255,255"
      secondary:  "255,255,255"
      detail:     "255,255,255"

  colors: -> @get('colors')

  initialize: ->
    @set('icon-200', @get('icon'))

    @compute 'icon-500', ->
      @get('icon-200').replace("square-200", "square-500")

    @set('icon', @get('icon-500')) #if devicePixelRatio > 1
    @analyze()

  analyze: ->
    if colors = App.memo('colors', @get('icon'))
      return @set {colors}

    Chloroform.analyze @get('icon-200'), (colors) =>
      @set 'colors', colors
      App.memo 'colors', @get('icon-200'), -> colors
