#= require models/artist
#= require ./items

class App.Collections.Artists extends App.Collections.Items
  method: 'getArtistsInCollection'
  model: App.Models.Artist
