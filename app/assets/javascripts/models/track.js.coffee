#= require ./artwork
#= require ./item

class App.Models.Track extends App.Models.Item
  toJSON: -> @pick 'name', 'album', 'artist', 'url', 'icon', 'key', 'duration'
  initialize: ->
    @artwork = new App.Models.Artwork(icon: @get('icon'))

    @compute 'full', ->
      @get('name') + " by " + @get('artist') + " on " + @get('album')

    @compute 'time', ->
      d = @get('duration')
      m = Math.floor(d / 60)

      s = d % 60
      s = '0' + s if s < 10

      "#{m}:#{s}"

    @listenTo this, 'change:icon', ->
      @artwork = new App.Models.Artwork(icon: @get('icon'))
