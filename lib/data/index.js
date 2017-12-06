import I from 'immutable'
import {mapObjIndexed} from 'ramda'

export const ID = String

export const Record = (types, name) => {
  const convert = values =>
    mapObjIndexed((f, k) => f(values[k]),types)

  const Parent = I.Record(convert({}))

  return values =>

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

export const Map = (x = {}) => x
export const List = (x = []) => x
