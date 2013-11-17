Component.new 'ActionMenu',
  tagName: 'ul'

  events:
    click: 'close'

  initialize: (options) ->
    App.actionMenu?.remove()
    App.actionMenu = this

    @items = options.items

  render: ->
    @delegateEvents()
    @$el.empty()

    for [text, callback, only] in @items
      continue if only? and not only

      $li = $("<li>")
      $li.text(text)
      $li.on 'click', callback
      @$el.append $li

    this

  close: (event) ->
    @remove()
    delete App.actionMenu
