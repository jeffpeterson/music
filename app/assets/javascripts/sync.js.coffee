Backbone.sync = (method, model, options = {}) ->
  unless R?.ready?()
    App.once 'rdio:ready', -> Backbone.sync(method, model, options)
    return

  content = _.omit options, 'success', 'error', 'parse', 'reset', 'method'
  App.debug 'Syncing with options:', options

  switch method
    when 'read'
      R.request
        method:  options.method or model.method
        success: options.success
        error:   options.error
        content: content

    when 'update' then throw "update not implemented"
    when 'create' then throw 'create not implemented'
    when 'delete' then throw 'delete not implemented'
    else
      throw "Invalid sync method: #{method}."

App.request = (method, options = {}) ->
  content = _.omit options, 'success', 'error', 'method'

  R.request
    method:  method
    success: options.success
    error:   options.error
    content: content
