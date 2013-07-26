#= require views/tracks/show

class App.Views.AlbumTrackShow extends App.Views.TrackShow
  events:
    'click .add-to-queue': 'add_to_queue'
    'click':               'play_now'
    'dragstart':           'dragstart'

  template: JST['albums/tracks/show']
