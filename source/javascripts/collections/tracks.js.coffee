#= require models/track
#= require collections/items

class App.Tracks extends App.Items
  model: App.Track
  comparator: 'dateAdded'
  url: "getTracksInCollection"
  save: ->
    localStorage.tracks = JSON.stringify @first(40)
