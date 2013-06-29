#= require views/tracks/show

class App.Views.AlbumTrackShow extends App.Views.TrackShow
  events:
    'click .play-now':     'play_now'
    'click .add-to-queue': 'add_to_queue'
    'click':               'play_now'
    'dragstart':           'dragstart'

  template: JST['albums/tracks/show']
