import {makeStoreFromReducers} from 'yak/makeStoreFromReducers'
import {Dispatcher} from 'core/Dispatcher'
import * as ColorReducers from 'reducers/ColorReducers'

export let ColorStore = makeStoreFromReducers(ColorReducers)
Dispatcher.register(ColorStore.handleAction)
