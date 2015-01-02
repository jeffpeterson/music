require('6to5/polyfill')

var React = require('react/addons')
var div = React.DOM.div

var Chloroform = require('chloroform')
var lib = require('../../lib')
var client = require('../../client')
var ctx = lib.ctx()

var Player = React.createFactory(require('../Player'))
var Header = React.createFactory(require('../Header'))
var Grid = React.createFactory(require('../Grid'))
var Queue = React.createFactory(require('../Queue'))
var Scroller = React.createFactory(require('../Scroller'))

module.exports = React.createClass({
  displayName: 'App',

  getInitialState() {
    return Object.assign({
      query: '',
      tracks: [],
      favorites: [],
      isLoading: true,
      isPlaying: true,
      scrubTime: 0,
      colors: [],
      queue: []
    }, this.load())
  },

  componentDidMount() {
    this.loadFirstPage()
    this.changeColorsToMatchTrack(this.state.queue[0])
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
        Scroller({ onUpdate: this.onScrollerUpdate, loadNextPage: this.loadNextPage },
          Grid({ controls, tracks: this.state.tracks })
        )
      )
    )
  },

  updateScrubTime(time) {
    // lib.debug('time update', time)
  },

  addToQueue(track) {
    var queue = addTrackToQueue(this.state.queue, track)
    return this.setState({queue})
  },

  play(track) {
    if (!track) {
      return
    }

    var queue = addTrackToQueue(this.state.queue, track)
    queue = rotateQueueToTrack(queue, track)
    return this.setState({queue})
  },


  advanceQueue() {
    var queue = rotateQueue(this.state.queue, 1)
    return this.setState({queue})
  },

  controls() {
    return {
      addToQueue: this.addToQueue,
      play: this.play,
      advanceQueue: this.advanceQueue
    }
  },

  setQuery(query) {
    return this.setState({query}, this.loadFirstPage)
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
  }
})

function uniqTracks(tracks) {
  var index = {}

  return tracks.reverse().filter(track => {
    if (!index[track.id]) {
      return index[track.id] = true
    }
  }).reverse()
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

function rotateQueue(queue, n) {
  if (!n) {
    return queue
  }

  lib.debug('rotating queue', n)

  return lib.rotate(queue, n)
}

function addTrackToQueue(queue, track) {
  return uniqTracks(queue.concat(track).reverse()).reverse()
}

function rotateQueueToTrack(queue, track) {
  return rotateQueue(queue, indexOfTrack(queue, track))
}

