import {Record, Map} from 'immutable'
import User from './User'

export default Record({
  id: 0,
  title: "",
  artworkUrl: "",
  streamUrl: "",
  user: User(),
}, 'Track')
