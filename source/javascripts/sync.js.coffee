Backbone.sync = (method, model, options = {}) ->
  content = _.omit options, 'success', 'error', 'parse', 'reset'

  console.log content
  switch method
    when 'read'
      model.current_request or= R.request
        method:  model.method
        success: (response) ->
          model.current_request = null
          options.success response.result
        error:   options.error
        content: content

    when 'create' then throw 'create not implemented'
    when 'update' then throw "update not implemented"
    when 'delete' then throw 'delete not implemented'
    else
      throw "invalid method: #{method}."

