import {Status} from '../records/Request'

import client from '../client'

export default dispatch => state => {
  state.requests.map(req => {
    switch (req.status) {
      case Status.Queued:
        start(req)
        .then(response => {
          dispatch('REQUEST_SUCCEEDED', {id: req.id, response})
        },
        dispatch('REQUEST_FAILED'))

        dispatch('REQUEST_STARTED', {id: req.id})
        break
    }
  })
}

const start = req => {
  console.log("Starting request", req)

  switch (req.type) {
    case 'GET_LIKES':
      return client.tracks(req.options)
  }
}
