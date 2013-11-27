Component.new 'Player',
  events:
    'click .pause': -> @model.pause()
    'click .play':  -> @model.play()
    'click .next':  -> @model.next()
    'click .prev':  -> @model.prev()
    'input .volume': 'update_volume'

  initialize: ->
    _.bindAll this, 'keypress', 'update_volume'
    @progressBar = new Component.ProgressBar(model: @model)
    @listenTo @model, 'change:state', @render

    $(window).on 'keydown', @keypress

  render: ->
    @delegateEvents()
    @$el.html @template(@model.attributes)

    @render_repeat()

    @$el.append @progressBar.render().el

    this

  render_repeat: ->
    @$('.repeat').removeClass('all one none').addClass(@model.get 'repeat')
    this

  update_volume: ->
    @model.set_volume $("#volume").val()

  keypress: (event) ->
    App.debug "Keypress:", event
    return if event.target isnt document.body

    switch event.which
      when 32
        event.preventDefault()
        @model.toggle()
      when 37#, 38
        event.preventDefault()
        @model.prev()
      when 39#, 40
        event.preventDefault()
        @model.next()
