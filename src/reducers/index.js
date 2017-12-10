import {identity, pipe, compose, not, indexBy, prop} from 'ramda'

import {addIn, getIn, setIn, mergeIn, updateIn, update} from '../logic/Immutable'
import * as Req from '../logic/Request'

import State from '../records/State'

export default (action) => {
  console.log("Action:", action)

  switch (action.type) {
    case 'INIT':
      return pipe(
        State,
        request('GET_LIKES', {}),
      )

    case 'SPACE_KEY_PRESSED':
    case 'PLAY_CLICKED':
      return togglePlaying

    case 'TRACK_CLICKED':
      return pipe(
        play,
        addToQueue(action.id),
        rotateQueueTo(action.id),
      )

    case 'REQUEST_STARTED':
      return pipe(
        update('requests', Req.started(action.id)),
      )

    case 'REQUEST_SUCCEEDED':
      return pipe(
        requestSucceeded(action.id),
        withRequest(action.id, req => {
          switch (req.type) {
            case 'GET_LIKES':
              return pipe(
                mergeIn(['tracks'], indexById(action.response)),
                // addIn(['likes'], action.response.map(prop('id'))),
              )

            default:
              return identity
          }
        })
      )

    default:
      return identity
  }
}

const indexById = indexBy(prop('id'))

const withRequest = (id, f) => state => f(state.getIn(['requests', id]))(state)
const request = compose(update('requests'), Req.push)
const requestSucceeded = compose(update('requests'), Req.succeeded)

// const togglePlaying = updateIn(['playState', 'isPlaying'], not)
// const play = setIn(['playState', 'isPlaying'], true)

// const addToQueue = id =>
//   addIn(['queue'], id)

// const rotateQueueTo = id => state =>
//   state.setIn([])

// var queue = addTrackToQueue(this.state.queue, track)
// queue = rotateQueueToTrack(queue, track)
// return this.setState({queue, isPlaying: true})
