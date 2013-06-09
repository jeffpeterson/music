class App.Track extends Backbone.Model
  idAttribute: 'key'
  initialize: ->
    @compute 'full', ->
      @get('name') + " by " + @get('artist') + " on " + @get('album')
