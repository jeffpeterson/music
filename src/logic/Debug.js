import {curry} from 'ramda'

export const trace = curry((tag, x) =>
  (console.log(`[TRACE] ${tag}:`, x), x))
