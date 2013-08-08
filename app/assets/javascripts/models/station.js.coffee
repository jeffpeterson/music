#= require ./artwork
#= require ./item

class App.Models.Station extends App.Models.Item
  initialize: ->
    @artwork = new App.Models.Artwork(icon: @get('icon'))
