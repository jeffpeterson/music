class App.Views.ItemShow extends Backbone.View
  tagName:   'li'
  className: 'item'
  attributes:
    draggable: true

  template: JST['item']

  initialize: ->
    @listenTo @model, 'change', @render
    @listenTo @model, 'remove', @remove

  events:
    'click .play-now':          'play_now'
    'click .add-to-queue':      'add_to_queue'
    'click .add-to-collection': 'add_to_collection'
    'dragstart':                'dragstart'


  render: ->
    @$el.attr 'data-index': @model.get('query')

  add_to_collection: (event) ->
    event.preventDefault()
    event.stopPropagation()

    @model.add_to_collection()

  dragstart: (event) ->
    event.originalEvent.dataTransfer.setData "text/json", JSON.stringify(@model)
    event.originalEvent.dataTransfer.setData "text/plain", @model.get('full')
