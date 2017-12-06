import {Record, Map} from 'immutable'

export const Status = {
  Queued: 'QUEUED',
  Pending: 'PENDING',
  Succeeded: 'SUCCEEDED',
  Failed: 'FAILED',
}

export default Record({
  id: 0,
  type: "",
  status: Status.Queued,
  options: Map(),
}, 'Request')
