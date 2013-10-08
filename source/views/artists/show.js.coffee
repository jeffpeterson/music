class App.Views.ArtistShow extends Backbone.View
  className: "artist"
  template: JST['templates/artists/show']

  render: ->
    @$el.html @template(artist: @model)
    this
