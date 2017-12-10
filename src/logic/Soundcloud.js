import {endpoint} from './Request'
import Track from '../records/Track'
import User from '../records/User'

export const request = endpoint({
  host: "https://api.soundcloud.com",
  params: {
    client_id: "nviGqqUJ1aoaFVSMA7EdLE3IZJLwYFKU",
  },
})

export const tracks = ({offset = 0, q} = {}) =>
  request({
    path: "/tracks.json",
    params: {offset, q},
  })

export const track = id =>
  request({
    path: `/tracks/${id}.json`,
  })

export const favorites = ({offset} = {}) =>
  request({
    path: "/me/favorites.json",
    params: {offset},
  })

export const reifyTrack = ({id, title, artwork_url, stream_url, user}) =>
  Track({
    id,
    title,
    artworkUrl: artwork_url,
    streamUrl: stream_url,
    user: reifyUser(user),
  })

export const reifyUser = ({id, username, avatar_url}) =>
  User({
    id,
    username,
    avatarUrl: avatar_url,
  })
