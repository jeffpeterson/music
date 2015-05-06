import {Record} from 'immutable'

let SearchState = Record({
  query: "",
  isFocused: false,
}, 'SearchState')

export function init() {
  return new SearchState()
}

export function setSearchQuery(state, {query}) {
  return state.set('query', query)
}
