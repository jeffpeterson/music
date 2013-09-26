#= require ./artwork
#= require ./item

class App.Models.Album extends App.Models.Item
  method: 'get'

  toJSON: -> this.pick 'name', 'url', 'icon', 'artist', 'displayDate', 'canStream'

  initialize: ->
    @artwork          = new App.Models.Artwork(icon: @get('icon'))
    @track_list       = new App.Collections.TrackList
    @track_list.album = this

    @listenTo this, 'change:icon', ->
      @artwork = new App.Models.Artwork(icon: @get('icon'))

    @compute 'query', ->
      @clean(@get('name') + @get('artist'))

    @compute 'route', ->
      return unless url     = @get('url')
      return unless match   = url.match("/artist/([^/]+)/album/([^/]+)/")
      [full, artist, album] = match

      "artists/#{artist}/albums/#{album}"

