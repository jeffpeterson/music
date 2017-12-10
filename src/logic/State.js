export const currentTrack = state =>
  state.tracks.get(state.queue.first())
