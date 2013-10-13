#= require views/items/index

class App.Views.PlaylistIndex extends App.Views.ItemIndex
  className: 'playlists'

  add: (playlist, options) ->
    @$el.append new App.Views.PlaylistShow(model: playlist).render().el
