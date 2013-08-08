#= require models/artist
#= require ./items

class App.Collections.Artists extends App.Collections.Items
  method: 'getArtistsInCollection'
  comparator: 'dateAdded'
  model: App.Models.Artist
