class App.Items extends Backbone.Collection
  current_request: null
  sync: (method, collection, options) ->
    _.defaults options,
      count: 100
      sort: 'dateAdded'
      extras: ""
      start: collection.length
    console.log options
    switch method
      when "read"
        @current_request ||= R.request
          method: @url
          content:
            count:  options.count
            sort:   options.sort
            start:  options.start
            extras: options.extras
          success: (response) ->
            collection.current_request = null
            collection.add response.result, merge: true
            collection.save()
  request: (attrs...) ->
    @fetch()
