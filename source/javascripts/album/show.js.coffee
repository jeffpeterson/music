#= require ./show

class App.AlbumView extends Backbone.View
  tagName: "li"
  className: "album"
  attributes:
    draggable: true

  template: JST['album/show']

  events:
    'click': 'click'

  render: ->
    @$el.html @template(album: @model)

    this

  click: (event) ->
    # event.preventDefault()
    # @last_element_in_row()
    
    # @$el.find(".album-art").transit(scale: 3, zIndex: 10)
    

  # drag: (event) ->
  #   event.originalEvent.dataTransfer.setData "text/json", JSON.stringify(@model)
  #   event.originalEvent.dataTransfer.setData "text/plain", @model.full()
  # last_element_in_row: ->
  #   $sibling = @$el
  #   while ($next = $sibling.next(@tagName))[0]
  #     $sibling = $next
      

