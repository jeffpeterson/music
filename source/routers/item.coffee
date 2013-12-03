class App.Routers.Item extends BetterRouter
  routes:
    ':artist/:album': 'album'

  initialize: ->
    @el = '#content'
    super(arguments...)

  album: (artist_name, album_name) ->
    App.routers.collection.index('albums')

    album = App.collection.albums.findWhere url: "/artist/#{artist_name}/album/#{album_name}/"
    unless album
      album = new App.Models.Album
        url: "/artist/#{artist_name}/album/#{album_name}/"
      album.fetch_by_url()

    view = new Component.Album.Modal model: album
    $("body").append view.render().el

  # artist: (artist_name) ->
  #   App.routers.collection.index('albums')

  #   url = "/artist/#{artist_name}/"

  #   artist = App.collection.albums.findWhere({url})
  #   unless artist
  #     artist = new App.Models.Artist({url})
  #     artist.fetch_by_url()

  #   view = new App.Views.Artist model: album
  #   $("body").append view.render().el
