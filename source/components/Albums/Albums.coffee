Component.new 'Albums', App.Views.ItemIndex,
  add: (album, options) ->
    index = album.collection.indexOf(album)
    @append new Component.Album(model: album).render().el, index
