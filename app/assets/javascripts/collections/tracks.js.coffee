#= require models/track
#= require collections/items

class App.Collections.Tracks extends App.Collections.Items
  model: App.Models.Track
  comparator: 'dateAdded'
  method: "getTracksInCollection"
