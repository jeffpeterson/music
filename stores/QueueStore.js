import {makeStoreFromReducers} from 'yak/makeStoreFromReducers'
import {Dispatcher} from 'core/Dispatcher'
import * as QueueReducers from 'reducers/QueueReducers'

let reducer = mergeReducers({
  player: PlayerReducer,
  log: (_, action) => {console.log("Action", action.type)}
})

export let QueueStore = makeStoreFromReducers(QueueReducers)
Dispatcher.register(QueueStore.handleAction)


// FIND HOMES FOR THIS STATE:
// tracks: [],
// favorites: [],
// isLoading: true,
// scrubTime: 0,
