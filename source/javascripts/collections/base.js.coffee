class App.Collections.Base extends Backbone.Collection
  lazy_fetch: (options = {}) ->
    if @length is 0
      _.defaults options, reset: true
      @fetch(options)
    this

