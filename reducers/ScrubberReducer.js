import {Record} from 'immutable'

let ScrubberState = Record({
  time: 0,
}, 'ScrubberState')

export function init() {
  return new ScrubberState()
}

export function setScrubTime(state, time) {
  return state.set('time', time)
}
