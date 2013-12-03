#= require ./base
#= require models/track

class App.Collections.TrackList extends App.Collections.Base
  model:      App.Models.Track
  method:     'get'
  comparator: 'trackNum'

  fetch: (options = {}) ->
    keys = @album.get('itemTrackKeys') or @album.get('trackKeys')
    call = arguments.callee

    if keys
      super _.defaults(options, keys: keys.join(','), extras: 'isInCollection')
    else
      @album.once 'change:trackKeys change:itemTrackKeys', =>
        call.apply(this, arguments)


  parse: (response, options) ->
    tracks = response.result
    _.values tracks

