import {get} from './Immutable'

export const currentTrack = state =>
  state.tracks.get(state.queue.first())

export const trackIds = get('favorites')
export const queueIds = get('queue')

export const tracks = state =>
  trackIds(state).toList().map(id => state.tracks.get(id)).filter(Boolean)

export const queue = state =>
  queueIds(state).toList().map(id => state.tracks.get(id)).filter(Boolean)
