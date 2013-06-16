class App.Artwork extends Backbone.Model
  defaults:
    icon: ''
    'icon-500': ''
    colors:
      background: '0,0,0'
      primary:    '255,255,255'
      secondary:  '255,255,255'
      detail:     '0,0,0'
  colors: ->
    ColorFinder.analyze @get('icon'), (colors) =>
      @set 'colors', colors
    @get('colors')
  initialize: ->
    @compute 'icon-500', ->
      @get('icon').replace("square-200", "square-500")
