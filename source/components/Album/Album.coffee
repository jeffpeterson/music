Component.new 'Album', ->
  @superClass App.Views.ItemShow
  @events
    click:     'show'
    dragstart: 'dragstart'

  @extras
    tagName: 'li'

    initialize: ->
      @sup::initialize?.apply(this, arguments)
      @listenTo @model.artwork, 'change', @render_colors

    render: ->
      @sup::render?.apply(this, arguments)
      unless @model.get("canStream")
        @$el.addClass "unavailable"
        @$el.attr draggable: false

      @$el.css backgroundImage: "url(#{@model.artwork.get('icon-500')})"
      this

    show: (event) ->
      event.preventDefault()

      view = new Component.Album.Modal model: @model, original: this
      view.render()
      $("body").append view.el
      view.in()

      App.go @model.get('route'), trigger: false
