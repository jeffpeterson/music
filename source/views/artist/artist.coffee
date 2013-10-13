class App.Views.ArtistShow extends Backbone.View
  className: "artist"
  template: JST['artist']

  render: ->
    @$el.html @template(artist: @model)
    this
