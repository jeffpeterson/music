String.prototype.capitalize = ->
  @charAt(0).toUpperCase() + @slice(1)

class Backbone.FormBuilder
  constructor: (@model) ->

  text_field:     (attribute, options) -> @input 'text',     attribute, options
  password_field: (attribute, options) -> @input 'password', attribute, options
  text_area:      (attribute, options) -> @input 'textarea', attribute, options
  checkbox:       (attribute, options = {}) ->
    if @model.get(attribute)
      options.checked = "checked"
    else
      delete options.checked
    @input 'checkbox', attribute, options

  label: (attribute, body = attribute, options = {}) ->
    _.defaults options,
      class: "#{attribute}_label"
      for: @id_for(attribute)

    label = @new_el 'label', options, body
    label.addClass 'error' if @model.validationError?[attribute]

    @new_el('p', {}, label).html()

  submit: (value, options = {}) ->
    _.defaults options, type: 'submit', value: value, class: 'submit'

    $el = @new_el 'input', options
    @new_el('p', {}, $el).html()

  # choices should be an object {value: name}
  select: (attribute, choices = {}, options = {}) ->
    _.defaults options,
      include_blank: false

    select = @new_el 'select', name: attribute
    for value, name of choices
      attrs = value: value
      attrs.selected = "selected" if @model.get(attribute) is value
      select.append @new_el('option', attrs, name)
    @new_el('p', {}, select).html()

  input: (type, attribute, options = {}) ->
    _.defaults options,
      name:        attribute
      class:       attribute
      placeholder: attribute.split("_").join(" ").capitalize()
      type:        type
      value:       @model.get attribute
      id:          @id_for(attribute)
      size:        30

    field = switch type
      when 'textarea'
        options.content = options.value
        options.value   = null

        @new_el 'textarea', options
      else
        @new_el 'input', options

    field.addClass 'error' if @model.validationError?[attribute]

    @new_el('p', {}, field).html()

  id_for: (attribute) ->
    "#{@model.constructor.name.toLowerCase()}_#{attribute}"

  errors_for: (attribute, options) ->
    if errors = @model.validationError?[attribute]
      el = @new_el('span', class: 'error', errors)

      @new_el('p', {}, el).html()

  new_el: (tag_name, attributes = {}, body) ->
    $("<#{tag_name} />", attributes).html(body?(this) || body)

Backbone.FormBuilder.form_for = window.form_for = (model, options, body) ->
  form_builder = new Backbone.FormBuilder(model)

  unless body
    body    = options
    options = {}

  _.defaults options,
    method: if model.isNew() then 'post' else 'put'
    action: model.url?() || model.url,

  form = form_builder.new_el 'form', options, body

  form.prop('outerHTML')
  $('<p>').append(form).html()
