#=require ./artwork

class App.Models.Album extends Backbone.Model
  idAttribute: "key"
  initialize: ->
    @artwork    = new App.Models.Artwork(icon: @get('icon'))
    @track_list = new App.Collections.TrackList
    @track_list.album = this
