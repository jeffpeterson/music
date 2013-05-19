#= require collection/index

class App.AlbumIndexView extends App.CollectionIndex
  add: (album) ->
    if @clean(album.get("name") + album.get("artist")).indexOf(@filter) >= 0
      @$ul.append new App.AlbumView(model: album).render().el
