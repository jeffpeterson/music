#= require views/tracks/show

class App.Views.AlbumTrackShow extends App.Views.TrackShow
  events:
    'click .add-to-queue':      'add_to_queue'
    'click .add-to-collection': 'add_to_collection'
    'click .play-now':          'play_now'
    'click':                    'highlight'
    'dragstart':                'dragstart'
    'dblclick':                 'play_now'

  template: JST['expanded_album/track']
