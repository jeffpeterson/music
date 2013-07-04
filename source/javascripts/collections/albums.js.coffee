#= require models/album
#= require ./items

class App.Collections.Albums extends App.Collections.Items
  model: App.Models.Album
  comparator: 'dateAdded'
  method: "getAlbumsInCollection"
