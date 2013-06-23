class App.Items extends Backbone.Collection
  current_request: null
  sync: (method, collection, options) ->
    _.defaults options,
      count: 100
      sort: 'dateAdded'
      extras: ""
      start: collection.length
    switch method
      when "read"
        unless @current_request
          @current_request = R.request
            method: @url
            content:
              count:  options.count
              sort:   options.sort
              start:  options.start
              extras: options.extras
            success: (response) ->
              collection.current_request = null
              collection.trigger 'change:current_request', collection

              collection.add response.result, merge: true
              collection.save()
            error: (response) ->
              collection.current_request = null
              console.error "Error!", response.message, response.code
          @trigger 'change:current_request', this

  request: (attrs...) ->
    @fetch(attrs...)
