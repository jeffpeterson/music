#= require ../items/index

class App.Views.AlbumIndex extends App.Views.ItemIndex
  className: 'albums'
  initialize: ->
    super()
    @listenTo App, 'infinite-scroll', ->
      @collection.fetch()

  add: (album) ->
    @$el.append new App.Views.AlbumShow(model: album).render().el
