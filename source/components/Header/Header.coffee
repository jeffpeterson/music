Component.new 'Header', ->
  @requires 'Player'
  @extras
    el: "#bar"

    events:
      'input #search': 'search'
      'click .sign-in': 'signIn'

    initialize: ->
      @playerView = new Component.Player(model: App.player)
      @searchView = new Component.Search

      @listenTo Backbone.history,  'route', @render_current_path
      @listenTo @searchView,       'search', @search
      @listenTo App.adapters.rdio, 'change:isAuthenticated', @render

      @render()

    render: ->
      @$el.html @template()
      @$(".search").replaceWith @searchView.render().el
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

    search: (query) ->
      App.trigger('search', query)
