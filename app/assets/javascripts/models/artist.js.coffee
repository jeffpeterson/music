#= require ./artwork
#= require ./item

class App.Models.Artist extends App.Models.Item
  toJSON: -> @pick 'icon', 'key', 'name'
  initialize: ->
    @artwork    = new App.Models.Artwork(icon: @get('icon'))
