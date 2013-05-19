class App.Track extends Backbone.Model
  idAttribute: 'key'
  full: ->
    @get('name') + " by " + @get('artist') + " on " + @get('album')

