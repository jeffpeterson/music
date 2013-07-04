#= require ./base
#= require models/track

class App.Collections.TrackList extends App.Collections.Base
  model: App.Models.Track
  method: 'get'
  comparator: 'trackNum'

  fetch: (options = {}) ->
    super _.defaults(options, keys: @album.get('itemTrackKeys').join(','))

  parse: (response, options) ->
    tracks = response.result
    for key in @album.get('trackKeys')
      tracks[key].inCollection = true
    _.values(tracks)

