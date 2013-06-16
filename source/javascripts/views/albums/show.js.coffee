class App.AlbumView extends Backbone.View
  tagName: "li"
  className: "album"
  attributes:
    draggable: true

  template: JST['albums/show']

  events:
    'click': 'click'

  render: ->
    @$el.html @template(album: @model)

    this

  click: (event) =>
    event.preventDefault()
    event.stopPropagation()

    $album = @$el.clone().addClass("expanded").css(position: 'absolute', top: @$el.position().top, left: @$el.position().left)

    @$el.addClass('invisible')
    @$el.parent().addClass 'blur'
    # $cover = $("<div>").css(position: 'absolute', top: 0, bottom: 0, left: 0, right: 0, zIndex: 4)
    $('body').on 'click', (e) =>
      $album.remove()
      @$el.parent().removeClass 'blur'
      @$el.removeClass('invisible')

    @$el.parent().parent().append $album

    # @last_element_in_row()
    
    # @$el.find(".album-art").transit(scale: 3, zIndex: 10)
    

  # drag: (event) ->
  #   event.originalEvent.dataTransfer.setData "text/json", JSON.stringify(@model)
  #   event.originalEvent.dataTransfer.setData "text/plain", @model.full()
  # last_element_in_row: ->
  #   $sibling = @$el
  #   while ($next = $sibling.next(@tagName))[0]
  #     $sibling = $next
      

