class App.Views.Drag extends Backbone.View
  el: document
  events:
    dragenter: 'dragenter'
    dragleave: 'dragleave'

  dragenter: (e) ->
    console.log "DRAG ENTER", e.target
    $(e.target).addClass('dragenter')

  dragleave: (e) ->
    $(e.target).removeClass('dragenter')

