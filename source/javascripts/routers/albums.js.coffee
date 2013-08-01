class App.Routers.Albums extends BetterRouter
  routes:
    'artists/:artist/albums/:album': 'show'

  initialize: ->
    @el = '#content'
    super(arguments...)

  show: (artist_name, album_name) ->
    album = new App.Models.Album
      url: "/artist/#{artist_name}/album/#{album_name}/"

    App.on 'rdio:ready', =>
      console.log "FETCHING ALBUM"
      album.fetch_by_url()
    @swap new App.Views.AlbumShow(model: album)
