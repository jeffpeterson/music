var React = require('react')
var div = React.DOM.div

var lib = require('../../lib')
var player = lib.player
var Header = React.createFactory(require('../Header'))
var Grid = React.createFactory(require('../Grid'))
var Queue = React.createFactory(require('../Queue'))
var Scroller = React.createFactory(require('../Scroller'))

module.exports = React.createClass({
  displayName: 'App',

  getInitialState: function() {
    return {
      query: 'testing',
      tracks: [],
      isLoading: true,
      queue: []
    }
  },

  componentDidMount: function() {
    search()
    .then(function(tracks) {
      if (!this.isMounted()) {
        return
      }


      this.setState({
        tracks: tracks,
        isLoading: false
      })
    }.bind(this))
  },

  render: function() {
    return div({className: 'App'},
      Header({
        player: player,
        query: this.state.query,
        setQuery: this.setQuery
      }),
      div({className: 'AppBody'},
        Queue({tracks: this.state.queue}),
        Scroller({loadNextPage: this.loadNextPage},
          Grid({
            play: this.play,
            tracks: this.state.tracks
          })
        )
      )
    )
  },

  play: function(track) {
    this.setState({ queue: [track] })
    player.play(track)
  },

  setQuery: function(query) {
    this.setState({query: query})
  },

  loadNextPage: function() {
    if (this.state.isLoading) {
      return
    }

    this.setState({ isLoading: true })

    return search({
      offset: this.state.tracks.length + 50,
      query: this.state.query
    })
    .then(function(tracks) {
      this.setState({
        isLoading: false,
        tracks: this.state.tracks.concat(tracks)
      })
    }.bind(this))
  }
})

function search(options) {
  options = options || {}
  var query = options.query
  var offset = options.offset || 0

  return lib.request({
    method: 'get',
    host: 'https://api.soundcloud.com',
    path: '/users/53101589/favorites.json',
    data: {
      client_id: '6da9f906b6827ba161b90585f4dd3726',
      limit: 50,
      offset: offset,
      q: query
    }
  })
}

