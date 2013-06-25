#= require models/artist
#= require ./items

class App.Collections.Artists extends App.Collections.Items
  method: 'getArtistsInCollection'
  model: App.Models.Artist

  fetch: (options = {}) ->
    super _.defaults options,
      count: 100
      sort: 'dateAdded'

