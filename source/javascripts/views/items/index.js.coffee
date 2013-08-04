class App.Views.ItemIndex extends Backbone.View
  tagName: "ul"

  initialize: ->
    @append_queue = []
    @flush_append_queue = _.debounce(@flush_append_queue, 300)

    @listenTo @collection, "reset", @render
    @listenTo @collection, "add", @add
    @listenTo @collection, "change:current_request", @loading

  in: ->
    @$el.css x: '100%', opacity: 0
    @$el.transit x: 0, opacity: 1

  out: ->
    @$el.transit x: '-100%', opacity: 0

  leave: ->
    @remove()

  render: =>
    @$el.empty()
    @collection.each (model) =>
      @add(model)
    this

  flush_append_queue: ->
    @$el.append(@append_queue)
    @append_queue = []

  append: ($el) ->
    @append_queue.push($el)
    @flush_append_queue()

  loading: (collection) ->
    if collection.current_request
      $("#logo").html $("<i>").addClass("icon spinner loading")
    else
      $("#logo").html "fst.io"
