#= require track
#= require item/items
class App.Tracks extends App.Items
  model: App.Track
  comparator: (m) -> - m.get("playCount")
  url: "getTracksInCollection"
  save: ->
    localStorage.tracks = JSON.stringify @first(40)
