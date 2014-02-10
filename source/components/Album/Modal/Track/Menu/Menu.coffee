Component.Album.Modal.Track.new 'Menu',
  tagName: 'ul'

  render: ->
    @$el.empty()

    isInCollection   = @model.get('isInCollection')
    isSyncedToMobile = @model.get('isSyncedToMobile')

    @menuItem 'Play Now',               this.playNow
    @menuItem 'Play Next',              this.playNext
    @menuItem 'Add to Queue',           this.add_to_queue
    @menuItem 'Add to Collection',      this.addToCollection,      !isInCollection
    @menuItem 'Sync to Mobile',         this.syncToMobile,         !isSyncedToMobile
    @menuItem 'Remove from Mobile',     this.removeFromMobile,      isSyncedToMobile
    @menuItem 'Remove from Collection', this.removeFromCollection,  isInCollection
    this

  in: (done) ->
    @$el.transit
      duration: 500
      complete: done
      opacity: 1
      height: 'auto'
    this

  out: (done) ->
    @$el.transit
      duration: 500
      complete: done
      opacity: 0
      height: 0
    this

  menuItem: (content, fn, only = true) ->
    return unless only
    @$el.append $("<li>").text(content).click(fn)

