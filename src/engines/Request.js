import {Status} from '../records/Request'
import {start} from '../logic/Request'

export default dispatch => state => {
  state.requests.map(req => {
    switch (req.status) {
      case Status.Queued:
        console.log("Starting request:", req)

        start(req)
        .then(result => {
          dispatch(req.success, {id: req.id, result})
        },
        error => dispatch(req.failure, {error}))

        dispatch(req.start, {id: req.id})

        break
    }
  })
}
