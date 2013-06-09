#= require collection/index

class App.TrackIndexView extends App.CollectionIndex
  className: 'tracks'
  add: (track) ->
    if @clean(track.get("name") + track.get("artist") + track.get("album")).indexOf(@filter) >= 0
      @$el.append new App.TrackView(model: track).render().el
