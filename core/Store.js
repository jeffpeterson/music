import Dispatcher from 'dispatcher'
import {OrderedMap, Map} from 'immutable'

export class Store {
  constructor(onChange) {
    this._onChange = onChange

    this._data = new Map({
      tracks: new OrderedMap(),
    })
  }

  get(id) {
    return _tracks.get(id)
  }

  getAll() {
    return _tracks
  }
}

Dispatcher.register(action => {
  switch (action.type) {
    case "create track":

      break;
    default:

  }
})


function(action, state) {
  switch (action.type) {
    case "addTrackToQueue":
      return state.updateIn(['queue'], q => q.add(action.track)

    default:

  }
}
