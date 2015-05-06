import {Record} from 'immutable'

let PlayerState = Record({
  isPlaying: false,
}, 'PlayerState')

export function init() {
  return new PlayerState()
}

export function playTrack(state, {track}) {
  return track ? play(state) : state
}

export function play(state) {
  return togglePlaying(state, true)
}

export function pause(state) {
  return togglePlaying(state, false)
}

export function togglePlaying(state) {
  return state.update('isPlaying', s => !s)
}

export function rotateQueueToTrack({queue}, track) {
  return rotateQueue({queue}, indexOfTrack(queue, track))
}

export function setScrubTime(_, scrubTime) {
  return {scrubTime}
}

export function setBassLevel(_, bassLevel) {
  return {bassLevel}
}

function indexOfTrack(queue, track) {
  let index = queue.findIndex(t => t.id === track.id)

  if (index >= 0) {
    return index
  }
}

function rotate(set, n = 0) {
  return set.skip(n).concat(set.take(n))
}
