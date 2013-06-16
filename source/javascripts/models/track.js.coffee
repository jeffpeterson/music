#= require artwork/artwork

class App.Track extends Backbone.Model
  idAttribute: 'key'
  initialize: ->
    @artwork = new App.Artwork(icon: @get('icon'))
    @compute 'full', ->
      @get('name') + " by " + @get('artist') + " on " + @get('album')
