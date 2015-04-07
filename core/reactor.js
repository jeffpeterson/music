import * as actions from './actions'

export function reactor(onChange) {
  let setState = makeStateSetter(render)({
    query: '',
    tracks: [],
    favorites: [],
    isLoading: true,
    isPlaying: true,
    scrubTime: 0,
    colors: {},
    queue: [],
    bassLevel: 0,
    ...load(),
  })

  function render(state) {
    onChange({
      ...state,
      actions: createActions(state, setState, actions)
    })
  }
}

function makeStateSetter(render) {
  let state = {}
  return function setState(delta) {
    state = {...state, ...delta}
    render(state)
  }
}

function createAction(state, setState, fn) {
  return function action(...args) {
    let delta = fn(...args)

    setState(delta)
  }
}

function createActions(state, setState, fns) {
  let actions = {}
  for (let k in fns) {
    actions[k] = createAction(state, setState, fns[k])
  }
  return actions
}
