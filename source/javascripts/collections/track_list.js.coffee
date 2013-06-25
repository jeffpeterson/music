#= require ./base
#= require models/track

class App.Collections.TrackList extends App.Collections.Base
  model: App.Models.Track
  method: 'get'
  comparator: 'trackNum'

  fetch: (options = {}) ->
    super _.defaults(options, keys: @album.get('itemTrackKeys').join(','))

  parse: (response, options) ->
    for key in @album.get('trackKeys')
      response[key].inCollection = true
    _.values(response)

