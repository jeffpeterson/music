class App.QueueView extends Backbone.View
  tagName: "ul"
  children: []

  events:
    'dragover': 'dragover'
    'drop':     'drop'
    'scroll':   'scroll'
    'click #current-track-fixed': ->
      try
        @$el.scrollTo "#current-track",
          duration: 500
          offset:
            top: -300

  initialize: ->
    @listenTo @collection, "reset", @render
    @listenTo @collection, "add", @add
    @listenTo @collection, "change:playingTrack", @change_playing_track

  render: ->
    @$el.append $("<li>").attr("id", "current-track-fixed")
    @previous_icon = null
    @collection.each (track) =>
      @add track
    this

  add: (track, queue) ->
    $el       = new App.QueueTrackShow(model: track).render().$el
    index     = @collection.indexOf(track)
    $children = @$el.children()

    if $children.length > 0
      $el.insertAfter $children[index - 1]
    else
      @$el.append $el

  change_playing_track: ->
    $("#current-track").removeAttr("id")
    @collection.current_track().trigger("current")

    $("#current-track-fixed").replaceWith(
      $("#current-track").clone().attr("id", "current-track-fixed"))

  dragover: (event) ->
    dt = event.originalEvent.dataTransfer
    event.preventDefault() if _.contains(dt.types, "text/json")

  drop: (event) =>
    event.preventDefault()

    data = event.originalEvent.dataTransfer.getData("text/json")
    App.queue.add JSON.parse(data)

  scroll: (event) ->
    $ct = $("#current-track")
    $ctf = $("#current-track-fixed")

    if $ct.offset().top < $("#player").height()
      $ctf.addClass("top").removeClass("bottom")
    else if $ct.offset().top + $ctf.height() > $("#queue").height()
      $ctf.addClass("bottom").removeClass("top")
    else
      $ctf.removeClass("top bottom")
