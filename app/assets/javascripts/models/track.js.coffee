#= require ./artwork
#= require ./item

class App.Models.Track extends App.Models.Item
  initialize: ->
    @artwork = new App.Models.Artwork(icon: @get('icon'))
    @compute 'full', ->
      @get('name') + " by " + @get('artist') + " on " + @get('album')
