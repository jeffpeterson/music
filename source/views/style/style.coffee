class App.Views.Style extends Backbone.View
  tagName: 'style'

  attributes:
    media:  'screen'
    type:   'text/css'
    scoped: true

  initialize: ->
    @styles  = {}

  render: ->
    @$el.html @stringified_styles()
    this

  css: (selector, properties) ->
    unless properties
      for sel, props of selector
        @css(sel, props)
      return

    cleaned_properties = @clean_properties(selector, properties)

    el = @styles[selector] or= {}
    @styles[selector] = _.defaults cleaned_properties, el

  clear: ->
    @styles  = {}

  stringified_styles: ->
    sels = for selector, properties of @styles
      "#{selector} {#{@stringified_properties(properties)}}"
    sels.join("\n")

  stringified_properties: (properties) ->
    props = for property, value of properties
      "#{property}: #{value};"

    props.join(' ')

  clean_properties: (selector, properties) ->
    cleaned_properties = {}

    for property, value of properties
      if typeof value is 'object'
        key = property.split(/[ ]*,[ ]*/g).map((k) ->
          if /&/.test k
            k.replace /&/g, selector
          else
            "#{selector} #{k}"
        ).join(', ')
        @css(key, value)

      else
        p = property.replace /[A-Z]/, (c) ->
          "-#{c.toLowerCase()}"

        cleaned_properties[p] = value

    cleaned_properties
