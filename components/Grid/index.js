var React = require('react')
var div = React.DOM.div
var lib = require('../../lib')
var GridTrack = React.createFactory(require('../GridTrack'))

module.exports = React.createClass({
  getInitialState: function() {
    return {
      tracks: []
    }
  },

  componentDidMount: function() {
    // return lib.request({
    //   method: 'get',
    //   host: 'https://api.soundcloud.com',
    //   path: '/users/53101589/favorites.json',
    //   data: {
    //     client_id: '6da9f906b6827ba161b90585f4dd3726'
    //   }
    // })
    return lib.request({
      method: 'get',
      host: window.location.host,
      path: '/mock-data/favorites.json'
    })
    .then(function(tracks) {
      this.setState({tracks: tracks})
    }.bind(this))
  },

  render: function() {
    return div({className: 'Grid'},
     this.state.tracks.map(function(track) {
       return GridTrack({
         onClick: this.props.play.bind(this, track),
         track: track,
         key: track.id
       })
     }.bind(this))
    )
  }
})
