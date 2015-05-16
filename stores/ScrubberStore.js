import {makeStoreFromReducers} from 'yak/makeStoreFromReducers'
import {Dispatcher} from 'core/Dispatcher'
import * as ScrubberReducers from 'reducers/ScrubberReducers'

export let ScrubberStore = makeStoreFromReducers(ScrubberReducers)
Dispatcher.register(ScrubberStore.handleAction)
