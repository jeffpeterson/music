import lib from '../lib'
var request = require('../lib/request')

module.exports = track

function track(id, options) {
  options = options || {}

  return request({
    method: 'get',
    host: 'https://api.soundcloud.com',
    path: `/tracks/${id}.json`,
    data: {
      client_id: lib.CLIENT_ID
    }
  })
}
