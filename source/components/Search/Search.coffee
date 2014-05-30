Component.new 'Search',
  tagName: 'input'

  attributes:
    type: 'text'
    placeholder: 'filter . . .'

  events:
    'input': 'onInput'

  render: ->
    @delegateEvents()

  onInput: (event) ->
    @trigger 'search', @el.value
