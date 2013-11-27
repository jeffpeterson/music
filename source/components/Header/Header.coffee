Component.new 'Header', ->
  @requires 'Player'
  @extras
    el: "#bar"

    events:
      'input #search': 'search'
      'click .sign-in': 'signIn'

    initialize: ->
      @listenTo Backbone.history, 'route', @render_current_path
      @playerView = new Component.Player(model: App.player)
      @render()

      @listenTo App.adapters.rdio, 'change:isAuthenticated', @render


    render: ->
      @$el.html @template()
      @$el.append @playerView.render().el

      @render_current_path()
      this

    render_current_path: ->
      fragment = Backbone.history.getHash()
      @$('a.current').removeClass('current')
      @$("a[href='##{fragment}']").addClass('current')
      this

    signIn: (event) ->
      event.preventDefault()
      R.authenticate()

    search: (event) ->
      App.trigger('search', event.target.value)
