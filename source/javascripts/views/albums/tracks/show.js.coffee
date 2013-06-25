#= require views/tracks/show

class App.Views.AlbumTrackShow extends App.Views.TrackShow
  template: JST['albums/tracks/show']
  # render: ->
  #   @$el.addClass('not-in-collection') unless @model.get('inCollection')
  #   super()

