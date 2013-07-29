#= require models/track

class App.Models.Playlist extends App.Models.Item
  initialize: ->
    @tracks = new App.Collections.Tracks
    delete @tracks.method
    delete @tracks.store
    delete @tracks.load

    @compute 'query', ->
      @clean(@get 'name')
