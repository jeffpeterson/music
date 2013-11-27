Component.new 'ActionMenu',
  events:
    click: 'close'

  initialize: (options) ->
    App.actionMenu?.remove()
    App.actionMenu = this

    @x = options.x
    @y = options.y

    @items = options.items
    @render()

  render: ->
    @delegateEvents()
    @$el.html @template()
    $ul = @$('ul')

    $ul.css left: -1000, top: -1000

    for [text, callback, only] in @items
      continue if only? and not only

      $li = $("<li>")
      $li.text(text)
      $li.click callback
      $ul.append $li

    $(document.body).append(@$el)

    $ul.css
      left: Math.min(@x, @$el.width() - $ul.width())
      top:  Math.min(@y, @$el.height() - $ul.height())

    this

  close: (event) ->
    @remove()
    delete App.actionMenu
