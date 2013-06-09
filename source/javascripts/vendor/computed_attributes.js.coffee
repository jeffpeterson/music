Backbone.ComputedAttributes =
  compute: (computed_attribute, options, fn) ->
    unless fn
      fn      = options
      options = {}
    model     = this
    clone     = Object.create(this)
    clone.get = (attribute) ->
      model.on 'change:' + attribute, ->
        model.set computed_attribute, fn.apply(this)
      model.get(attribute)

    model.set computed_attribute, fn.apply(clone)

Backbone.Model.prototype.compute = Backbone.ComputedAttributes.compute
