#= require artist
#= require item/items
class App.Artists extends App.Items
  # localStorage: new Backbone.LocalStorage("App.collection.artists")
  url: 'getArtistsInCollection'
  model: App.Artist
