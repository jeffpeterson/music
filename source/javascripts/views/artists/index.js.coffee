#= require views/items/index

class App.ArtistIndexView extends App.ItemsIndex
  add: (artist) ->
    if @clean(artist.get("name")).indexOf(@filter) >= 0
      @$ul.append new App.ArtistView(model: artist).render().el
