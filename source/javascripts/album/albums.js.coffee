#= require album
class App.Albums extends Backbone.Collection
  model: App.Album
  url: "getAlbumsInCollection"
  sync: (method, collection, options) ->
    switch method
      when "read"
        R.request
          method: @url
          content:
            count: options.count || 100
            sort:  options.sort || 'playCount'
            start: options.start || 0
          success: (response) ->
            collection.set response.result
  request: (attrs...) ->
    @fetch()
