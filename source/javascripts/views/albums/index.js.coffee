#= require ../items/index

class App.Views.AlbumIndex extends App.Views.ItemIndex
  className: 'albums'

  add: (album, options) ->
    @$el.append new App.Views.AlbumShow(model: album).render().el
