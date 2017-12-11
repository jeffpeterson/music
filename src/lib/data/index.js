import I from 'immutable'
import {mapObjIndexed} from 'ramda'

export const defaulted = (T, def) => x =>
  x != null ? T(x) : def

export const ID = String
export const URL = String

// Record({id: ID})({id: 3}).toJS() -> {id: "3"}
export const Record = (types, name) => {
  const convert = (values = {}) =>
    mapObjIndexed((f, k) => values[k] != null ? f(values[k]) : f(), types)

  const Parent = I.Record(convert({}))

  return vals =>
    Parent(convert(vals))
}

// export const Record = (types, name) => {
//   function Record(values) {
//     if (!this instanceof Record) return new Record(values)

//     Object.assign(this, values)
//   }

//   Record.name = name
//   Record.prototype = proto

//   return Record
// }

export const Map = I.Map
export const List = I.List
export const OrderedSet = I.OrderedSet
export const OrderedMap = I.OrderedMap
