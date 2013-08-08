#= require ./items
#= require models/playlist

class App.Collections.Playlists extends App.Collections.Items
  model:      App.Models.Playlist
  comparator: 'name'
  method:     'getPlaylists'

  parse: (resp, options = {}) ->
    super {result: resp.result.owned}, options

