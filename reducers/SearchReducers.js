import {Record} from 'immutable'

let SearchState = Record({
  query: "",
  isFocused: false,
}, 'SearchState')

export function init() {
  return SearchState()
}

export function searchQuerySet(state, {query}) {
  return state.set('query', query)
}
