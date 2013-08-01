#= require views/tracks/show

class App.Views.AlbumTrackShow extends App.Views.TrackShow
  events:
    'click .add-to-queue':      'add_to_queue'
    'click .add-to-collection': 'add_to_collection'
    'click':                    'play_now'
    'dragstart':                'dragstart'

  template: JST['albums/tracks/show']
