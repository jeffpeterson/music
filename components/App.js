import Chloroform from 'chloroform'
import lib from 'lib'
import client from 'client'
import {key} from 'lib/keyboard'
import {css} from 'lib/css'
import {rgb} from 'lib/color'

let ctx = lib.ctx()

import './Ratio'
import {Base} from './Base'
import {Hue} from './Hue'
import {Player} from './Player'
import {Header} from'./Header'
import {Grid} from './Grid'
import {Queue} from './Queue'
import {Scroller} from './Scroller'
import {Scrubber} from './Scrubber'
import {WaveForm} from './WaveForm'
import {Search} from './Search'

export class App extends Base {
  constructor(props) {
    super(props)

    this.state = {
      query: '',
      tracks: [],
      favorites: [],
      isLoading: true,
      isPlaying: true,
      scrubTime: 0,
      colors: {},
      queue: [],
      bassLevel: 0,
      ...this.load()
    }

    this.addToQueue = this.addToQueue.bind(this)
    this.removeFromQueue = this.removeFromQueue.bind(this)
    this.setQuery = this.setQuery.bind(this)
    this.play = this.play.bind(this)
    this.advanceQueue = this.advanceQueue.bind(this)
    this.store = this.store.bind(this)
    this.loadNextPage = this.loadNextPage.bind(this)
    this.loadFirstPage = this.loadFirstPage.bind(this)
    this.handleScrubTimeUpdate = this.handleScrubTimeUpdate.bind(this)
    this.setBassLevel = this.setBassLevel.bind(this)
    this.onKeyDown = this.onKeyDown.bind(this)

    this.controls = {
      addToQueue: this.addToQueue,
      removeFromQueue: this.removeFromQueue,
      advanceQueue: this.advanceQueue,
      play: this.play,
    }
  }

  componentDidMount() {
    this.loadFirstPage()
    this.changeColorsToMatchTrack(this.currentTrack())
    window.addEventListener('unload', this.store)
    window.addEventListener('keydown', this.onKeyDown)
  }

  componentDidUnmount() {
    window.removeEventListener('unload', this.store)
  }

  componentWillUpdate(props, state) {
    if (state.queue[0] !== this.state.queue[0]) {
      this.changeColorsToMatchTrack(state.queue[0])
    }
  }

  render() {
    let {
      setBassLevel, onKeyDown, controls,
      state: {bassLevel, queue, colors, tracks, isPlaying, query, scrubTime}
    } = this
    let currentTrack = this.currentTrack()

    return (
      <div className="App" style={this.style()} onKeyDown={onKeyDown}>
        <Hue {...{colors, bassLevel}} />
        <Player {...{ctx, isPlaying}}
          ref="player"
          track={currentTrack}
          onEnded={this.advanceQueue}
          onError={this.advanceQueue}
          scrubTime={scrubTime}
          updateScrubTime={this.handleScrubTimeUpdate} />

        <Header {...{colors}} >
          <Scrubber {...{colors, scrubTime}}
            duration={currentTrack && currentTrack.duration}
            onScrub={this.handleScrubTimeUpdate} />

          <WaveForm {...{ctx, currentTrack, colors, setBassLevel}}
            isDimmed={!!query} />

          <Search {...{query}}
            onChange={this.setQuery}
            onConfirm={this.loadFirstPage} />

        </Header>

        <div className="App-body">
          <Queue controls={controls} tracks={queue} />
          <Scroller loadNextPage={this.loadNextPage}>
            <Grid controls={controls} tracks={tracks} />
          </Scroller>
        </div>
      </div>
    )
  }

  style() {
    return {
      backgroundColor: rgb(this.state.colors.background)
    }
  }

  onKeyDown(e) {
    switch (key(e.which)) {
      case 'right':
        this.advanceQueue()
        break
      case 'space':
        this.togglePlaying()
        break

      default:
        return
    }

    e.preventDefault()
  }


  request(options) {
    if (this.state.query) {
      return client.tracks(options)
    } else {
      return client.favorites(options)
    }
  }

  loadFirstPage() {
    this.request({
      query: this.state.query
    })
    .then(tracks => {
      this.setState({ tracks, isLoading: false })
    })
  }

  loadNextPage({isLoading, tracks, query}) {
    return new Promise((resolve, reject) => {
      requestAnimationFrame(() => {
        if (isLoading) {
          return
        }

        debug('loading next page with offset:', this.state.tracks.length)

        this.setState({ isLoading: true })

        return this.request({
          offset: this.state.tracks.length,
          query: this.state.query
        })
        .then(tracks => {
          lib.debug('received', tracks.length, 'tracks')

          this.setState({
            isLoading: false,
            tracks: uniqTracks(this.state.tracks.concat(tracks))
          })
        })
        .catch(e => {
          this.setState({isLoading: false})
        })
      })
    })
  }

  currentTrack() {
    return this.state.queue[0]
  }

  changeColorsToMatchTrack(track) {
    if (!track) {
      return
    }

    Chloroform.analyze(artUrl(track), colors => {
      this.setState({ colors: colors })
    })
  }

  store() {
    var json = JSON.stringify(lib.only(this.state,
      'queue',
      'query',
      'isPlaying',
      'colors',
      'scrubTime'
    ))

    window.localStorage.setItem('App.state', json)
  }

  load() {
    var str = window.localStorage.getItem('App.state')

    if (str) {
      return JSON.parse(str)
    }

    return {}
  }
}

css('.App', {
  height: '100%',
  position: 'relative',
  backgroundColor: 'black',
  color: '#888',
  fontFamily: 'Helvetica Neue',
  fontWeight: 200,
  overflow: 'hidden',
})

css('.App-body', {
  height: '100%',
  display: 'flex',
  alignItems: 'stretch',
  position: 'relative',
  overflow: 'hidden',
})

css('html, body, #mount', {
  margin: 0,
  padding: 0,
  height: '100%',
  position: 'relative',
  overflow: 'hidden',
})

css('::-webkit-scrollbar', {
  display: 'none',
})

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}
