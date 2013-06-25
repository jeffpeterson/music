#= require models/album
#= require ./items

class App.Collections.Albums extends App.Collections.Items
  model: App.Models.Album
  method: "getAlbumsInCollection"
  fetch: (options = {}) ->
    super _.defaults options,
      count: 100
      sort: 'dateAdded'
  store: ->
    localStorage.albums = JSON.stringify @first(40)
