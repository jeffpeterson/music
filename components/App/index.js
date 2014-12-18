var React = require('react')
var div = React.DOM.div

var player = require('../../lib/player')
var Queue = React.createFactory(require('../Queue'))
var Content = React.createFactory(require('../Content'))

function mp3Url(track) {
  return track.stream_url + '?client_id=6da9f906b6827ba161b90585f4dd3726'
}

module.exports = React.createClass({
  play: function(track) {
    player.play(mp3Url(track))
  },

  getInitialState: function() {
    return {}
  },

  render: function() {
    return div({className: 'App'},
      Queue(),
      Content({
        play: this.play,
        analyser: player.analyser
      })
    )
  }
})
