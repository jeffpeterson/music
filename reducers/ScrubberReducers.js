import {Record} from 'immutable'

let ScrubberState = Record({
  time: 0,
}, 'ScrubberState')

export function init() {
  return ScrubberState()
}

export function scrubTimeChanged(state, time) {
  return state.set('time', time)
}
