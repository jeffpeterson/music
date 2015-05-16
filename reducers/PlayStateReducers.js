import {Record} from 'immutable'

let PlayerState = Record({
  isPlaying: false,
}, 'PlayerState')

export function init() {
  return new PlayerState()
}

export function trackPlayed(state, {track}) {
  return track ? played(state) : state
}

export function played(state) {
  return state.set('isPlaying', true)
}

export function paused(state) {
  return state.set('isPlaying', false)
}

export function playToggled(state) {
  return state.update('isPlaying', s => !s)
}

export function queueRotatedToTrack(state) {
  return played(state)
}
