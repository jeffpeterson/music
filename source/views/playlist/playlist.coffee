class App.Views.PlaylistShow extends Backbone.View
  tagName: "li"
  className: "playlist"

  template: JST['playlist']

  initialize: ->
    @listenTo @model, 'remove', @remove

  render: ->
    unless @model.get("canStream")
      @$el.addClass "unavailable" 
      @$el.attr draggable: false

    @$el.html @template(playlist: @model)
    this
