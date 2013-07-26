class App.Models.Item extends Backbone.Model
  idAttribute: 'key'
  clean: (string) ->
    string.toLowerCase().replace(/[^a-z0-9]/i, '')
