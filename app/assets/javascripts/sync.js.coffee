Backbone.sync = (verb, model, options = {}) ->
  unless R?.ready?()
    App.once 'rdio:ready', -> Backbone.sync(verb, model, options)
    return

  content = _.omit options, 'success', 'error', 'parse', 'reset', 'method', 'adapter'
  App.debug 'Syncing with options:', options

  method  = options.method or model.method
  adapter = options.adapter or model.adapter or 'rdio'
  success = options.success
  error   = options.error

  switch verb
    when 'read'
      # App.adapters[adapter].get method,
      #   success: success
      #   error:   error

      R.request
        method:  method
        success: success
        error:   error
        content: content

    when 'update' then throw "update not implemented"
    when 'create' then throw 'create not implemented'
    when 'delete' then throw 'delete not implemented'
    else
      throw "Invalid sync method: #{verb}."

App.request = (method, options = {}) ->
  content = _.omit options, 'success', 'error', 'method'

  R.request
    method:  method
    success: options.success
    error:   options.error
    content: content
