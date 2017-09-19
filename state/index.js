import {Record, List, Map, OrderedSet} from 'immutable'
import {identity, always} from 'ramda';

const State = Record({
  query: '',
  tracks: Map(), // ID -> Track
  users: Map(), // ID -> User
  favorites: OrderedSet(), // OrderedSet ID
  currentUser: null, // ID
  requests: List(), // List Request
  isPlaying: true,
  scrubTime: 0, // Milliseconds
  colors: Map(),
  queue: OrderedSet(), // OrderedSet ID
})

const init = State();

export const BOOT = () =>
  always(init)


export default action => {
  switch (action.type) {
    case 'BOOT':
      return always(init)

    case 'TRACK_ADDED_TO_QUEUE':
      return
    default:
      return identity
  }
}

    addToQueue
    removeFromQueue
    setQuery
    play
    advanceQueue
    store
    loadNextPage
    loadFirstPage
    handleScrubTimeUpdate
    setBassLevel
    onKeyDown
