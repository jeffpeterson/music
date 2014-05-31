#= require views/items/index

class App.Views.TrackIndex extends App.Views.ItemIndex
  className: 'tracks'
  add: (track) ->
    @$el.append new Component.Track(model: track).render().el
