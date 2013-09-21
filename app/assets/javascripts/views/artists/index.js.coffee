#= require views/items/index

class App.Views.ArtistIndex extends App.Views.ItemIndex
  add: (artist, options) ->
    index = artist.collection.indexOf(artist)
    @append new App.Views.ArtistShow(model: artist).render().el, index
