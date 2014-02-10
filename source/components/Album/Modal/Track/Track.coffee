Component.Album.Modal.new 'Track', App.Views.TrackShow,
  events:
    'click .action-menu-button': 'toggleMenu'
    'click .add-to-collection':  'add_to_collection'
    'click .add-to-queue':       'add_to_queue'
    'click':                     'play_now'
    'dragstart':                 'dragstart'

  toggleMenu: (event) ->
    event.stopPropagation()

    if @menuVisible then @hideMenu() else @showMenu()

  hideMenu: ->
    @menu.out(@menu.remove.bind(@menu))
    @menuVisible = false

  showMenu: ->
    @menuVisible = true

    @menu or= new Component.Album.Modal.Track.Menu(model: @model)

    @$el.append @menu.render().$el.css(opacity: 0, height: 0)

    @menu.in()
