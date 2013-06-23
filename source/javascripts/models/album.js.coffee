#=require ./artwork

class App.Album extends Backbone.Model
  idAttribute: "key"
  url: "getTracksForAlbumInCollection"
  initialize: ->
    @artwork = new App.Artwork(icon: @get('icon'))
