App.Component.new 'Items', ->
  @requires 'Item'
  @tag 'li'

  @before 'render', ->
    @styles or= new App.Views.Style

  @def 'render', ->
    @$el.html @template(this)

  @def 'filter', (query) ->
    @styles.clear()
    if query is ''
      @styles.render()
      return
    css = {}
    css["#content > ul > li:not([data-index*=\"#{query}\"])"] = display: 'none !important'
    @styles.css css
    @styles.render()
