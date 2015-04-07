// Each action accepts _state_ as the first argument
// and returns a delta that is merged with state.
//
// It might be better for each action to merge the
// delta with _state_ before returning.
// Easy to change later.

import {rotate} from 'lib/array'

export function addToQueue({queue}, track) {
  return {queue: uniqTracks(queue.concat(track).reverse()).reverse()}
}

export function removeFromQueue({queue}, track) {
  let i = indexOfTrack(queue, track)

  if (i == null) {
    return
  }

  return {queue: queue.slice(0, i).concat(queue.slice(i + 1))}

}

export function advanceQueue(state) {
  return rotateQueue(state, 1)
}

export function play(state, track) {
  if (!track) {
    return
  }

  return {
    ...rotateQueueToTrack(addToQueue(state, track), track),
    isPlaying: true
  }
}

export function pause() {
  return {isPlaying: false}
}

export function togglePlaying({isPlaying}) {
  return {isPlaying: !isPlaying}
}

export function setQuery(_, query) {
  return {query}
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

export function loadNextPage({isLoading, tracks, query}) {
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


function rotateQueue({queue}, n) {
  return {queue: rotate(queue, n)}
}

function uniqTracks(tracks) {
  var index = {}

  return tracks.reverse().filter(track => {
    if (!index[track.id]) {
      return index[track.id] = true
    }
  }).reverse()
}

function indexOfTrack(queue, track) {
  let index = queue.findIndex(t => t.id === track.id)

  if (index >= 0) {
    return index
  }
}
