import {OrderedSet} from 'immutable'
import {id} from 'utils/TrackUtils'

export function init() {
  return OrderedSet()
}

export function trackAddedToQueue(queue, {track}) {
  const _id = id(track)
  return queue.add(_id)
}

export function trackRemovedFromQueue(queue, {track}) {
  const _id = id(track)
  return queue.remove(_id)
}

export function queueAdvanced(queue) {
  return advance(queue, 1)
}

export function trackPlayed(queue, {track}) {
  if (!track) {
    return queue
  }

  return queueAdvancedToTrack(addToQueue(state, {track}), {track})
}

export function queueAdvancedToTrack(queue, {track}) {
  return advance(queue, indexOfTrack(queue, track))
}

function indexOfTrack(queue, track) {
  let _id = id(track)
  let index = findIndex(queue, i => i === _id)

  if (index >= 0) {
    return index
  }
}

function findIndex(set, fn) {
  let i = set.takeUntil(fn).size
  return i < set.size ? i : -1
}

function advance(set, n = 0) {
  return set.skip(n).concat(set.take(n))
}
