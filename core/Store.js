import {mergeReducers} from 'yak/mergeReducers'
import {makeStoreFromReducer} from 'yak/makeStoreFromReducer'

import {Dispatcher} from './Dispatcher'

import * as PlayerReducer from 'reducers/PlayerReducer'
import * as QueueReducer from 'reducers/QueueReducer'

let reducer = mergeReducers({
  queue: QueueReducer,
  player: PlayerReducer,
  log: (_, action) => {console.log("Action", action.type)}
})

export let Store = makeStoreFromReducer(reducer)
Dispatcher.register(Store.handleAction)


// FIND HOMES FOR THIS STATE:
// tracks: [],
// favorites: [],
// isLoading: true,
// scrubTime: 0,
