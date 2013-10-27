class App.Routers.Albums extends BetterRouter
  routes:
    ':artist/:album': 'show'

  initialize: ->
    @el = '#content'
    super(arguments...)

  show: (artist_name, album_name) ->
    App.routers.Collection.index('albums')

    album = App.collection.albums.findWhere url: "/artist/#{artist_name}/album/#{album_name}/"
    unless album
      album = new App.Models.Album
        url: "/artist/#{artist_name}/album/#{album_name}/"
      album.fetch_by_url()

    view = new App.Views.AlbumExpanded model: album
    $("body").append view.render().el
