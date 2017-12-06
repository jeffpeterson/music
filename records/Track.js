import {Record, Map} from 'immutable'
import User from './User'

export default Record({
  id: ID,
  title: String,
  artwork_url: String,
  stream_url: String,
  user: User(),
}, 'Track')
