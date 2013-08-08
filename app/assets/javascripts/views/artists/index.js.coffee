#= require views/items/index

class App.Views.ArtistIndex extends App.Views.ItemIndex
  add: (artist) ->
    if @clean(artist.get("name")).indexOf(@filter) >= 0
      @$ul.append new App.Views.ArtistShow(model: artist).render().el
