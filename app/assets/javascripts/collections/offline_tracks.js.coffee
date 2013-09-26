#= require ./tracks

class App.Collections.OfflineTracks extends App.Collections.Tracks
  model: App.Models.Track
  comparator: 'name'
  method: 'getOfflineTracks'

  initialize: ->
    super(arguments...)
    @lazy_fetch()

  fetch: (options = {}) ->
    super _.defaults options, count: 5000
