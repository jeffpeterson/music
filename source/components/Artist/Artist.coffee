Component.new 'Artist',
  render: ->
    @$el.html @template(@model.attributes)
    this
