#= require views/items/index

class App.Views.TrackIndex extends App.Views.ItemIndex
  className: 'tracks'
  add: (track) ->
    @$el.append new App.Views.TrackShow(model: track).render().el
