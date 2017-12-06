import {endpoint} from './Request'

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
