import {defaulted, Record, Map, URL} from 'lib/data'

export const Status = {
  Queued: 'QUEUED',
  Pending: 'PENDING',
  Succeeded: 'SUCCEEDED',
  Failed: 'FAILED',
}

export default Record({
  id: String,
  method: defaulted(String, 'get'),
  status: defaulted(String, Status.Queued),
  host: String,
  path: URL,
  params: Map,
  start: defaulted(String, 'REQUEST_STARTED'),
  success: defaulted(String, 'REQUEST_SUCCEEDED'),
  failure: defaulted(String, 'REQUEST_FAILED'),
}, 'Request')
