import {curry} from 'ramda'

export const update = curry((k, f, s) =>
  s.update(k, f))

export const setIn = curry((p, x, s) =>
  s.setIn(p, x))

export const getIn = curry((p, s) =>
  s.getIn(p))

export const updateIn = curry((p, f, s) =>
  s.updateIn(p, f))

export const mergeIn = curry((p, x, s) =>
  s.mergeIn(p, x))

export const add = curry((k, s) =>
  s.add(x))

export const addIn = curry((p, x, s) =>
  s.updateIn(p, add(x)))

export const merge = curry((x, y) =>
  y.merge(x))
