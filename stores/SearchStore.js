import {makeStoreFromReducers} from 'yak/makeStoreFromReducers'
import {Dispatcher} from 'core/Dispatcher'
import * as SearchReducers from 'reducers/SearchReducers'

export let SearchStore = makeStoreFromReducers(SearchReducers)
Dispatcher.register(SearchStore.handleAction)
