import {identity, pipe, compose, not, indexBy, prop, map} from 'ramda'

import {add, addIn, getIn, setIn, mergeIn, updateIn, update, push, concat, rotateTo} from '../logic/Immutable'
import * as Req from '../logic/Request'

import State from '../records/State'
import * as SoundCloud from '../logic/SoundCloud'

export default (action) => {
  console.log("Action:", action)

  switch (action.type) {
    case 'INIT':
      return pipe(
        State,
        request(SoundCloud.favorites()),
      )

    case 'SPACE_KEY_PRESSED':
    case 'PLAY_CLICKED':
      return togglePlaying

    case 'TRACK_CLICKED':
      return play(action.id)

    case 'REQUEST_STARTED':
      return pipe(
        updateRequests(Req.started(action.id)),
      )

    case 'FAVORITES_RECEIVED':
      return pipe(
        requestSuccess(action.id),
        addFavorites(action.result),
      )

    case 'REQUEST_SUCCEEDED':
      return requestSuccess(action.id)

    default:
      return identity
  }
}

const updateFavorites = update('favorites')
const updateRequests = update('requests')
const updateQueue = update('queue')

const mergeTracks = mergeIn(['tracks'])
const ids = map(pipe(prop('id'), String))

const addFavorites = tracks =>
  pipe(
    mergeTracks(indexById(SoundCloud.reifyTracks(tracks))),
    updateFavorites(concat(ids(tracks)))
  )

const indexById = indexBy(prop('id'))

const withRequest = (id, f) => state => f(state.getIn(['requests', id]))(state)
const requestSuccess = compose(update('requests'), Req.succeeded)

const request = req =>
  updateRequests(Req.push(req))

// const togglePlaying = updateIn(['playState', 'isPlaying'], not)

const playing = setIn(['playState', 'isPlaying'])

const play = id =>
  pipe(
    playing(true),
    updateQueue(add(id)),
    Debug.trace('before rotate'),
    rotateQueueTo(id),
    Debug.trace('after rotate'),
  )

const rotateQueueTo = id =>
  updateQueue(rotateTo(id))

// var queue = addTrackToQueue(this.state.queue, track)
// queue = rotateQueueToTrack(queue, track)
// return this.setState({queue, isPlaying: true})
