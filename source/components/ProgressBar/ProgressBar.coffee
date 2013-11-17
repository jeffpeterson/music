Component.new 'ProgressBar',
  className: 'progress-bar'

  events:
    'click .click-area': 'onClick'
    mousemove: 'onMouseMove'

  initialize: ->
    @listenTo @model, 'change:position', @renderPosition

  render: ->
    @delegateEvents()
    @$el.html @template(@model.attributes)
    @renderPosition()

    this

  onClick: (event) ->
    @model.setFloatPosition event.offsetX / $(event.target).width()
    @renderPosition()

  onMouseMove: (event) ->
    @renderTime(event.offsetX / $(event.target).width())

  renderTime: (floatX) ->
    track = App.queue.get('current_track')
    return unless track

    percent = floatX * 100 + "%"

    @$('.time').text(@time(floatX * track.get('duration'))).css left: percent

  time: (seconds) ->
    seconds = Math.floor(seconds)
    minutes = Math.floor(seconds / 60) + ""
    seconds = seconds % 60 + ""
    seconds = "0" + seconds if seconds.length < 2
    minutes + ":" + seconds

  renderPosition: ->
    track = App.queue.get('current_track')
    return this unless track

    percent = @model.get('position') / track.get('duration') * 100 + "%"
    @$('.position').css width: percent
    this
