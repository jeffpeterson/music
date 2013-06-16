class App.ArtistView extends Backbone.View
  className: "artist"
  template: JST['artists/show']

  render: ->
    @$el.html @template(artist: @model)
    this
