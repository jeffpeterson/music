#= require models/artist
#= require ./items

class App.Collections.Artists extends App.Collections.Items
  method: 'getArtistsInCollection'
  comparator: 'name'
  model: App.Models.Artist

  fetch: (options = {}) ->
    super _.defaults(options, sort: 'name')
