import Chloroform from 'chloroform'
import lib from 'lib'
import client from 'client'
import {key} from 'lib/keyboard'
import {css} from 'lib/css'
import {rgb} from 'lib/color'
import {currentTrack} from '../logic/State'

let ctx = lib.ctx()

import './Ratio'
import Base from './Base'
import Hue from './Hue'
import Player from './Player'
import Header from'./Header'
import GridTracks from './GridTracks'
import Queue from './Queue'
import Scrubber from './Scrubber'
import WaveForm from './WaveForm'
import Search from './Search'
import Nav from './Nav'
import Window from './Window'

export default class App extends Base {
  render() {
    const {state, dispatch} = this.props

    const {
      colors, playState, query, queue, favorites, tracks, tab,
    } = state
    const {isPlaying, scrubTime} = playState

    const trackIds = favorites

    // doesn't work over https:
    // <Hue {...{colors, bassLevel}} />

    return (
      <div className="App" style={this.style()}>
        <Window
          onKeyDown={this.onKeyDown}
          onUnload={this.store}
        />

        <Player {...{ctx, playState}}
          ref="player"
          track={currentTrack(state)}
          dispatch={dispatch} />

        <Header {...{colors}} >
          <Scrubber {...{colors, scrubTime, dispatch}}
            duration={currentTrack && currentTrack.duration} />

          <WaveForm {...{isPlaying, ctx, currentTrack, colors}}
            isDimmed={!!query} />

          <Search {...{query, dispatch}} />

          <Nav>
            <Nav.Item selected={tab == 'stream'}>Stream</Nav.Item>
            <Nav.Item selected={tab == 'likes'}>Likes</Nav.Item>
            <Nav.Item selected={tab == 'search'}>Search</Nav.Item>
          </Nav>
        </Header>

        <div className="App-body">
          <Queue dispatch={dispatch} tracks={queue} />

          <GridTracks
            tracks={trackIds.map(id => tracks.get(id))}
            {...{tab, dispatch}} />
        </div>
      </div>
    )
  }

  style() {
    const {colors} = this.props.state

    return {
      backgroundColor: rgb(colors.background),
      color: rgb(colors[0]),
    }
  }

  onKeyDown = e => {
    const {dispatch} = this.props

    switch (key(e.which)) {
      case 'right':
        dispatch('RIGHT_KEY_PRESSED', null)
        break

      case 'left':
        dispatch('LEFT_KEY_PRESSED', null)
        break

      case 'space':
        dispatch('SPACE_KEY_PRESSED', null)
        break

      default:
        return
    }

    e.preventDefault()
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

function addTrack(tracks, track) {
  return uniqTracks(tracks.concat(track))
}

function removeTrackFromQueue(queue, track) {
  let i = indexOfTrack(queue, track)

  if (i == null) {
    return queue
  }

  return queue.slice(0, i).concat(queue.slice(i + 1))
}

function rotateQueueToTrack(queue, track) {
  return rotateQueue(queue, indexOfTrack(queue, track))
}
