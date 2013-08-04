#= require ../items/index

class App.Views.AlbumIndex extends App.Views.ItemIndex
  className: 'album-list'

  add: (album, options) ->
    @append new App.Views.AlbumShow(model: album).render().el
