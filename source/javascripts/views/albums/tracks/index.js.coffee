#= require views/tracks/index

class App.Views.AlbumTrackIndex extends App.Views.TrackIndex
  className: 'track-list tracks'
  initialize: ->
    @listenTo @collection, "reset", @render

    @colors = @collection.album.artwork.colors()
    @$el.css
      backgroundColor: "rgb(#{@colors.background})"
      color: "rgb(#{@colors.primary})"

  render: ->
    super()

    $("body").css
      backgroundColor: "rgb(#{@colors.background})"
    this

  add: (track) ->
    @$el.append new App.Views.AlbumTrackShow(model: track).render().el
