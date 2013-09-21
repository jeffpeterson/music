#= require monkey_patches
#= require jquery
#= require underscore
#= require backbone

window.L = {}
L.tap = (fn) ->
  (args...) ->
    fn.apply(this, args)
    this

Object.setPrototypeOf ||= (obj, proto) -> obj.__proto__ = proto

base = L


base.Component = Backbone.View.extend()


# base.Component = (options) -> @initialize(options)
base.Component.EmptyComponent = ->

base.Component.parent                 = base.Component.EmptyComponent
base.Component.parent.allRequirements = -> {}
base.Component.parent._name           = 'Component.EmptyComponent'
base.Component.parent.children        = {}
base.Component.parent.Component       = base.Component

base.Component._name  = 'Component'

base.Component.init = L.tap (@parent) ->
  @parent.children[@_name] = this

  _.defaults @prototype,
    children:   []
    classNames: [@_name.dasherize().replace('.', '-')]
    tagName:    'div'

  @requirements = {}
  @children     = {}

base.Component.init(base.Component.parent)

base.Component.clone = ->
  component = ->
  Object.setPrototypeOf component, this
  component

base.Component.new = (name, initializer) ->
  if this[name]
    throw new Error("#{this}.#{name} already exists!")

  c = this[name] = this.clone()

  c._name = if this is base.Component
    name
  else
    "#{this._name}.#{name}"
  c.init(this)


  c.requirements[@_name] or= this

  initializer?.call?(c, this)
  return c

base.Component.delete = (names...) ->
  for name in names
    component = @deref(name)

    delete component.parent[name]
    delete component.parent.children[name]

base.Component.requires = (names...) ->
  for name in names
    @requirements[name] or= @deref(name)

base.Component.deref = (name) ->
  return base.Component if name is 'Component'

  [match, rest, name] = name.match(/^(?:(.*)\.)?([^.]+)$/i)

  if rest
    @deref(rest)[name]
  else
    if this[name]
      this[name]
    else
      @parent.deref(name)

base.Component.EmptyComponent.deref = (name) ->
    return this[name] if this[name]
    throw new Error("Component named '#{name}' not found!")

base.Component.allRequirements = ->
  _.defaults @parent.allRequirements(), @requirements

base.Component.addFilter = (type, name, callback) ->
  f = (@filters[type][name] or= [])
  f.push callback

base.Component.callFilter = (obj, type, name, args) ->
  return true unless filters = @filters[type][name]
  for filter in filters
    return false unless filter.apply(obj, args)
  true

base.Component.el = (selector) ->
  document.querySelector selector

base.Component.tag = (name) ->
  @prototype.tagName = name

base.Component.class = (names...) ->
  @prototype.classNames = @prototype.classNames.concat names...

base.Component.extends = (names...) ->
  @requires names...
  for name in names
    _.extend @prototype, @deref(name)

base.Component.def = (name, fn) ->
  this::[name] = fn

base.Component.after = (name, callback) ->
  fn = this::[name]
  this::[name] = ->
    r = fn.apply(this, arguments)
    callback.apply(this, arguments)
    return r

base.Component.before = (name, callback) ->
  fn = this::[name]
  this::[name] = ->
    callback.apply(this, arguments)
    fn.apply(this, arguments)

base.Component.around = (name, callback) ->
  fn = this::[name]
  this::[name] = ->
    callback.call(this, fn, arguments...)
