#= require models/artist
#= require ./items

class App.Artists extends App.Items
  url: 'getArtistsInCollection'
  model: App.Artist
