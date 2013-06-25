class App.Models.Artwork extends Backbone.Model
  defaults:
    icon: ''
    'icon-500': ''

  colors: ->
    colors = @get('colors') or App.memo 'colors', @get('icon')
    return colors if colors

    @analyze()
    @get('colors')

  initialize: ->
    @set('icon-200', @get('icon'))

    @compute 'icon-500', ->
      @get('icon-200').replace("square-200", "square-500")

    @set('icon', @get('icon-500')) if devicePixelRatio > 1

  analyze: ->
    ColorFinder.analyze @get('icon'), (colors) =>
      @set 'colors', colors
      App.memo 'colors', @get('icon'), -> colors
