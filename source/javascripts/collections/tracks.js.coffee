#= require models/track
#= require collections/items

class App.Collections.Tracks extends App.Collections.Items
  model: App.Models.Track
  comparator: 'dateAdded'
  method: "getTracksInCollection"

  fetch: (options = {}) ->
    super _.defaults options,
      count: 100
      sort: 'dateAdded'

  store: ->
    localStorage.tracks = JSON.stringify @first(40)
