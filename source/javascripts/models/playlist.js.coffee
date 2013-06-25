#= require models/track

class App.Models.Playlist extends Backbone.Model
  initialize: ->
    @tracks = new App.Collections.Tracks
    delete @tracks.url
    delete @tracks.save

