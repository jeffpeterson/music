Backbone.sync = (method, model, options = {}) ->
  content = _.omit options, 'success', 'error', 'parse', 'reset'
  App.debug 'Syncing with options:', options

  switch method
    when 'read'
      R.request
        method:  model.method
        success: options.success
        error:   options.error
        content: content

    when 'create' then throw 'create not implemented'
    when 'update' then throw "update not implemented"
    when 'delete' then throw 'delete not implemented'
    else
      throw "Invalid sync method: #{method}."

