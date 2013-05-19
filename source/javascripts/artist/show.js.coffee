#= require ./show

class App.ArtistView extends Backbone.View
  className: "artist"
  template: JST['artist/show']

  render: ->
    @$el.html @template(artist: @model)
    this