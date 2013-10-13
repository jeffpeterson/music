class App.Views.ItemIndex extends Backbone.View
  tagName: "ul"

  initialize: ->
    @listenTo @collection, "reset", @render
    @listenTo @collection, "add", @add
    @listenTo @collection, "change:current_request", @loading
    @listenTo @collection, 'filter', @filter

  in: ->
    @$el.css x: '100%', opacity: 0
    @$el.transit x: 0, opacity: 1

  out: ->
    @$el.transit x: '-100%', opacity: 0

  leave: ->
    @remove()

  render: =>
    @styles or= new App.Views.Style
    @$el.empty()
    @$el.append @styles.render().el

    @$el.append $('<div>').addClass('loading') if @collection.length is 0

    @collection.each (model) =>
      @add(model)
    this

  filter: (query) ->
    @styles.clear()
    if query is ''
      @styles.render()
      return

    css = {}
    css["#content > ul > li:not([data-index*=\"#{query}\"])"] = display: 'none !important'
    @styles.css css
    @styles.render()

  append: (el, index) ->
    # $children = @$el.children()
    @$el.append el
    # if not index or index is $children.length or index is 0
    #   @$el.append el
    # else
    #   $children[index].before el

  loading: (collection) ->
    if collection.current_request
      $("#logo").html $("<i>").addClass("icon spinner loading")
    else
      $("#logo").html "fst.io"
