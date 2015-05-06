import {OrderedSet} from 'immutable'

import {Track} from 'records/Track'

export function init() {
  return new OrderedSet()
}

export function addTrackToQueue(queue, {track}) {
  return queue.add(track)
}

export function removeTrackFromQueue(queue, {track}) {
  return queue.remove(track)
}

export function advanceQueue(queue) {
  return rotate(queue, 1)
}

export function playTrack(queue, {track}) {
  if (!track) {
    return queue
  }

  return {
    ...advanceQueueToTrack(addToQueue(state, track), track),
    isPlaying: true
  }
}

export function advanceQueueToTrack(queue, track) {
  return rotateQueue({queue}, indexOfTrack(queue, track))
}

function indexOfTrack(queue, track) {
  let index = findIndex(queue, t => t.id === track.id)

  if (index >= 0) {
    return index
  }
}

function findIndex(set, fn) {
  let i = set.takeUntil(fn).size
  return i < set.size ? i : -1
}

function rotate(set, n = 0) {
  return set.skip(n).concat(set.take(n))
}
