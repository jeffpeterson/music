var React = require('react/addons')
var div = React.DOM.div

var lib = require('../../lib')
var client = require('../../client')

var Grid = React.createFactory(require('../Grid'))
var Scroller = React.createFactory(require('../Scroller'))

module.exports = React.createClass({
  displayName: 'Favorites',

  getInitialState() {
    return Object.assign({
      tracks: [],
      isLoading: true,
    }, this.load())
  },

  componentDidMount() {
    this.loadFirstPage()
  },

  componentDidUpdate(props, state) {
    this.store(this.state)
  },

  componentWillUpdate(props, state) {
    if (state.queue[0] !== this.state.queue[0]) {
      this.changeColorsToMatchTrack(state.queue[0])
    }
  },

  render() {
    var controls = this.controls()

    var style = {
      backgroundColor: 'rgb(' + this.state.colors.background + ')'
    }

    return div({className: 'App', style: style },
      Player({
        ctx,
        track: this.state.queue[0],
        isPlaying: this.state.isPlaying,
        onEnded: this.advanceQueue,
        onError: this.advanceQueue,
        updateScrubTime: this.updateScrubTime,
      }),

      Header(
        {
          ctx,
          colors: this.state.colors,
          currentTrack: this.currentTrack(),
          query: this.state.query,
          setQuery: this.setQuery
        }
      ),
      div({ className: 'AppBody' },
        Queue({ controls, tracks: this.state.queue }),
        Scroller({ loadNextPage: this.loadNextPage },
          Grid({ controls, tracks: this.currentList() })
        )
      )
    )
  },

  updateScrubTime(time) {
    lib.debug('time update', time)
  },

  rotateQueue(n) {
    if (!n) {
      return
    }

    lib.debug('rotating queue', n)

    this.setState({
      queue: lib.rotate(this.state.queue, n)
    })
  },

  rotateQueueToTrack(track) {
    this.rotateQueue(indexOfTrack(this.state.queue, track))
  },

  addToQueue(track) {
    this.setState({
      queue: uniqTracks(this.state.queue.concat(track))
    })
  },

  play(track) {
    if (!track) {
      return
    }

    this.addToQueue(track)
    this.rotateQueueToTrack(track)
  },


  advanceQueue() {
    this.rotateQueue(1)
  },

  controls() {
    return {
      addToQueue: this.addToQueue,
      play: this.play,
      advanceQueue: this.advanceQueue
    }
  },

  setQuery(query) {
    this.setState({query}, this.loadFirstPage)
  },

  request: function(options) {
    if (this.state.query) {
      return client.tracks(options)
    } else {
      return client.favorites(options)
    }
  },

  loadFirstPage() {
    this.request({
      query: this.state.query
    })
    .then(tracks => {
      this.setState({
        tracks: tracks,
        isLoading: false
      })
    })
  },

  loadNextPage() {
    if (this.state.isLoading) {
      return
    }

    this.setState({ isLoading: true })

    return this.request({
      offset: this.state.tracks.length,
      query: this.state.query
    })
    .then(tracks => {
      this.setState({
        isLoading: false,
        tracks: uniqTracks(this.state.tracks.concat(tracks))
      })
    })
  },

  currentTrack() {
    return this.state.queue[0]
  },

  changeColorsToMatchTrack(track) {
    if (!track) {
      return
    }

    Chloroform.analyze(artUrl(track), colors => {
      this.setState({ colors: colors })
    })
  },

  store(state) {
    var json = JSON.stringify(lib.only(state,
      'queue',
      'query',
      'isPlaying',
      'colors'
    ))

    window.localStorage.setItem('App.state', json)
  },

  load() {
    var str = window.localStorage.getItem('App.state')

    if (str) {
      return JSON.parse(str)
    }

    return {}
  },

  currentList() {
    if (this.state.query) {
      return this.state.tracks
    } else {
      return this.state.favorites
    }
  }
})

function uniqTracks(tracks) {
  var index = {}

  return tracks.filter(track => {
    if (!index[track.id]) {
      return index[track.id] = true
    }
  })
}

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}


function indexOfTrack(queue, track) {
  var index = queue.findIndex(t => t.id === track.id)

  if (index >= 0) {
    return index
  }
}

