import {compose, mergeDeepRight} from 'ramda'
import {toJS} from './Immutable'
import Request, {Status} from '../records/Request'
import makeRequest from 'lib/request'

export const endpoint = defaults => req =>
  Request(defaults).mergeDeep(req)

export const push = req => reqs =>
  reqs.push(req.set('id', reqs.size))

export const started = id => reqs =>
  reqs.setIn([id, 'status'], Status.Pending)

export const succeeded = id => reqs =>
  reqs.setIn([id, 'status'], Status.Succeeded)

export const start = req =>
  makeRequest({
    method: req.method,
    host: req.host,
    path: req.path,
    data: toJS(req.params),
  })
