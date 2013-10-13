Backbone.ComputedAttributes =
  compute: (computed_attribute, options, fn) ->
    unless fn
      fn      = options
      options = {}

    lazy      = options.lazy or false
    model     = this
    clone     = Object.create(this)
    clone.get = (attribute) ->
      model.on 'change:' + attribute, ->
        model.set computed_attribute, fn.apply(this)
      model.get(attribute)

    if lazy
      model.get = (key) ->
        return @constructor::get.apply(this, key) unless key is computed_attribute
        @set computed_attribute, fn.apply(clone)
        delete @get
        @constructor::get.apply(this, key)
    else
      model.set computed_attribute, fn.apply(clone)

Backbone.Model::compute = Backbone.ComputedAttributes.compute
