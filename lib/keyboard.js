import {debug} from 'lib'

export function key(which) {
  let k = keys[which] || ''

  debug('keyboard', which, k)
  return k
}

let keys = {
  13: 'return',
  27: 'esc',
  32: 'space',
  39: 'right',
}
