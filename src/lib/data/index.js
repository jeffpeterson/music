import I from 'immutable'
import {mapObjIndexed} from 'ramda'

export const ID = String

/// Record({id: ID})({id: 3}).toJS() -> {id: "3"}
export const Record = (types, name) => {
  const convert = values =>
    mapObjIndexed((f, k) => f(values[k]), types)

  const Parent = I.Record(convert({}))


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
