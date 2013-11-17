Component.new 'Header', ->
  @requires 'Player'
  @extras
    el: "#bar"

    events:
      'input #search': 'search'

    initialize: ->
      @listenTo Backbone.history, 'route', @render_current_path
      @playerView = new Component.Player(model: App.player)
      @playerView.render()

      @$el.html @template()
      @$el.append @playerView.el

    render: ->
      @render_current_path()
      this

    render_current_path: ->
      fragment = Backbone.history.getHash()
      @$('a.current').removeClass('current')
      @$("a[href='##{fragment}']").addClass('current')
      this

    search: (event) ->
      App.trigger('search', event.target.value)
