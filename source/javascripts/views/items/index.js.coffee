class App.Views.ItemIndex extends Backbone.View
  tagName: "ul"

  initialize: ->
    @listenTo @collection, "reset", @render
    @listenTo @collection, "add", @add
    @listenTo @collection, "change:current_request", @loading

  in: ->
    @$el.css opacity: 0
    @$el.transit opacity: 1

  out: ->
    @$el.transit opacity: 0

  leave: ->
    @remove()

  render: =>
    @$el.empty()
    @collection.each (model) =>
      @add(model)
    this

  loading: (collection) ->
    if collection.current_request
      $("#logo").html $("<i>").addClass("icon spinner loading")
    else
      $("#logo").html "fst.io"
