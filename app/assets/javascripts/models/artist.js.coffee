#= require ./artwork
#= require ./item

class App.Models.Artist extends App.Models.Item
  initialize: ->
    @artwork    = new App.Models.Artwork(icon: @get('icon'))
