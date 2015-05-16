import {makeStoreFromNestedReducers} from 'yak/makeStoreFromNestedReducers'

import {Dispatcher} from './Dispatcher'

import * as ColorReducers from 'reducers/ColorReducers'
import * as PlayStateReducers from 'reducers/PlayStateReducers'
import * as QueueReducers from 'reducers/QueueReducers'
import * as ScrubberReducers from 'reducers/ScrubberReducers'
import * as SearchReducers from 'reducers/SearchReducers'

export let Store = makeStoreFromNestedReducers({
  colors: ColorReducers,
  playState: PlayStateReducers,
  queue: QueueReducers,
  scrubber: ScrubberReducers,
  search: SearchReducers,
  log: (_, action) => {console.log("Action", action.type)}
})

Dispatcher.register(Store.handleAction)
