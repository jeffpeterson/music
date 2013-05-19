class App.Album extends Backbone.Model
  idAttribute: "key"
  url: "getTracksForAlbumInCollection"
  sync: (method, model, options) ->
    switch method
      when "read"
        R.request
          method: @url
          content:
            album: @model.get("albumKey")
          success: (response) =>
            App.queue.reset response.result
            App.queue.play()
