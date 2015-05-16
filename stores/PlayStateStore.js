import {makeStoreFromReducers} from 'yak/makeStoreFromReducers'
import {Dispatcher} from 'core/Dispatcher'
import * as PlayStateReducers from 'reducers/PlayStateReducers'

export let PlayStateStore = makeStoreFromReducers(PlayStateReducers)
Dispatcher.register(PlayStateStore.handleAction)
