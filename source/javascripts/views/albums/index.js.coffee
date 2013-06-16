#= require ../items/index

class App.AlbumIndexView extends App.ItemsIndex
  className: 'albums'
  add: (album) ->
    if @clean(album.get("name") + album.get("artist")).indexOf(@filter) >= 0
      @$el.append new App.AlbumView(model: album).render().el
