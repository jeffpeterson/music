import {Record} from 'immutable'

let ColorState = Record({
  background: "0,0,0",
  contrast: "255,255,255",
  0: "255,255,255",
  1: "255,255,255",
  2: "255,255,255",
}, 'ColorState')

export function init() {
  return ColorState()
}

export function colorsReceivedFromAlbum(state, colors) {
  return state.merge(colors)
}
