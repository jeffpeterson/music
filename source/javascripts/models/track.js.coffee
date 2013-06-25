#= require ./artwork

class App.Models.Track extends Backbone.Model
  idAttribute: 'key'
  initialize: ->
    @artwork = new App.Models.Artwork(icon: @get('icon'))
    @compute 'full', ->
      @get('name') + " by " + @get('artist') + " on " + @get('album')
