Component.Album.Modal.new 'Tracks', parent = App.Views.TrackIndex,
  initialize: ->
    @listenTo @collection, "reset", @render

  render: ->
    parent::render.apply(this, arguments)
    this

  add: (track) ->
    @$el.append new Component.Album.Modal.Track(model: track).render().el
