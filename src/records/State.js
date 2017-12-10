import PlayState from './PlayState'
import Colors from './Colors'
import {List, Map, OrderedSet, Record} from 'immutable'

export default Record({
  query: '',
  tab: 'likes',
  requests: List(),
  playState: PlayState(),
  tracks: Map(), // Map ID Track
  likes: OrderedSet(), // ID
  favorites: OrderedSet(), // ID
  isLoading: true,
  colors: Colors(),
  queue: OrderedSet(),
  bassLevel: 0,
}, 'State')
