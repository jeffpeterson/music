#= require album
#= require item/items

class App.Albums extends App.Items
  model: App.Album
  url: "getAlbumsInCollection"
  save: ->
    localStorage.albums = JSON.stringify @first(40)
