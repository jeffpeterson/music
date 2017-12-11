import I from 'immutable'

export const toJS = x =>
  x && x.toJS ? x.toJS() : x

export const update = k => f => struc =>
  struc.update(k, f)

export const setIn = p => x => s =>
  s.setIn(p, x)

export const get = k => struc =>
  struc.get(k)

export const getIn = p => s =>
  s.getIn(p)

export const updateIn = p => f => s =>
  s.updateIn(p, f)

export const mergeIn = path => x => struc =>
  struc.mergeIn(path, x)

export const add = x => struc =>
  struc.add(x)

export const addIn = p => x => s =>
  s.updateIn(p, add(x))

export const merge = x => struc =>
  struc.merge(x)

export const push = x => struc =>
  struc.push(x)

// concat([1])(I.list([2])) -> I.List([2, 1])
export const concat = x => struc =>
  struc.concat(x)

export const rotate = struc => n =>
  struc.slice(n % struc.size).concat(struc.slice(0, n % struc.size))

/// rotateTo('b')(List(['a', 'b', 'c'])) -> List(['b', 'c', 'a'])
export const rotateTo = x => struc => {
  const first = struc.skipUntil(y => I.is(x, y))
  return first.concat(struc.skipLast(first.size))
}
