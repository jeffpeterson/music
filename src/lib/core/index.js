import {is} from 'immutable'
import {curry} from 'ramda'
import {debounce} from 'lodash'

export const combineEngines = fs => dispatch => {
  fs = fs.map(f => f(dispatch))

  return state =>
    fs.forEach(f => f(state))
}

export const main = (reduce, engine, f) => {
  let state;

  const emit = debounce(() => {
    console.log("Emit state: ", state)
    f(state)
    engine(state)
  })

  const dispatch = curry((type, props) => {
    const ts = new Date().toISOString()
    const action = {type, ts, ...props}

    const prev = state
    state = reduce(action)(state)

    if (!is(prev, state)) emit()
  })

  f = f(dispatch)
  engine = engine(dispatch)

  dispatch('INIT', null)
}
