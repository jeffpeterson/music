import {curry, compose, mergeDeepRight} from 'ramda'
import Request, {Status} from '../records/Request'

export const endpoint = defaults =>
  compose(Request, mergeDeepRight(defaults))

export const push = curry((type, options, reqs) =>
  reqs.push(Request({id: reqs.size, type, options})))

export const started = curry((id, reqs) =>
  reqs.setIn([id, 'status'], Status.Pending))

export const succeeded = curry((id, reqs) =>
  reqs.setIn([id, 'status'], Status.Succeeded))
