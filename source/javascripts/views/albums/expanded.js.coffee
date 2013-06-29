#= require ./show

class App.Views.AlbumExpanded extends Backbone.View
  className: 'expanded-album'

  template: JST['albums/expanded']
  initialize: ->

  render: ->
    @track_list or= new App.Views.AlbumTrackIndex collection: @model.track_list
    @colors     or= @model.artwork.colors()
    @model.track_list.lazy_fetch()

    @$el.html @template(album: @model)

    @$('.back').html @track_list.render().el
    @$('ul').css
      backgroundColor: "rgb(#{@colors.background})"
    this
