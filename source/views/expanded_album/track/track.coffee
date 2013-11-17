#= require views/tracks/show

class App.Views.AlbumTrackShow extends App.Views.TrackShow
  events:
    'click .action-menu-button': 'toggleActionMenu'
    'click .add-to-collection':  'add_to_collection'
    'click .add-to-queue':       'add_to_queue'
    'click .play-now':           'play_now'
    'click':                     'highlight'
    'dragstart':                 'dragstart'

  template: JST['expanded_album/track']


  toggleActionMenu: (event) ->
    if @$el.has('.action-menu').length
      @hideActionMenu()
    else
      @showActionMenu()

  showActionMenu: ->
    isInCollection = @model.get('isInCollection')
    new Component.ActionMenu(items: [
      ['Play Now',               this.play_now]
      ['Play Next',              this.playNext]
      ['Add to Queue',           this.add_to_queue]
      ['Add to Collection',      this.add_to_collection,    !isInCollection]
      ['Remove from Collection', this.removeFromCollection, isInCollection]
    ])

    @$el.append App.actionMenu.render().el

  hideActionMenu: ->
    App.actionMenu?.remove()
    delete App.actionMenu


