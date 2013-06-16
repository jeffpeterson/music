#= require collection/index

class App.ArtistIndexView extends App.CollectionIndex
  add: (artist) ->
    if @clean(artist.get("name")).indexOf(@filter) >= 0
      @$ul.append new App.ArtistView(model: artist).render().el
