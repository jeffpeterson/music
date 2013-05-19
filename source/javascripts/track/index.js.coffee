#= require collection/index

class App.TrackIndexView extends App.CollectionIndex
  add: (track) ->
    if @clean(track.get("name") + track.get("artist") + track.get("album")).indexOf(@filter) >= 0
      @$ul.append new App.TrackView(model: track).render().el
