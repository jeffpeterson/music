#= require album
#= require item/items
class App.Albums extends App.Items
  model: App.Album
  url: "getAlbumsInCollection"
