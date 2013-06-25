#= require ./base

class App.Collections.Items extends App.Collections.Base
  method: 'get'
  sync: (method, collection, options) ->
    Backbone.sync method, collection, _.defaults options,
      count: 100
      sort: 'dateAdded'
      extras: ""
      start: collection.length

