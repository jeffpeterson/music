#= require views/tracks/index

class App.Views.AlbumTrackIndex extends App.Views.TrackIndex
  className: 'track-list'
  initialize: ->
    @listenTo @collection, "reset", @render

  render: ->
    super()
    this

  add: (track) ->
    @$el.append new App.Views.AlbumTrackShow(model: track).render().el
