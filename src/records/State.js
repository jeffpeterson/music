import PlayState from './PlayState'
import Colors from './Colors'
import {defaulted, List, Map, OrderedSet, Record} from 'lib/data'

export default Record({
  query: String,
  tab: defaulted(String, 'favorites'),
  requests: List,
  playState: PlayState,
  tracks: Map, // Map ID Track
  favorites: OrderedSet, // ID
  isLoading: defaulted(Boolean, true),
  colors: Colors,
  queue: OrderedSet,
  bassLevel: Number,
}, 'State')
