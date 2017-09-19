import lib from '../lib'
var request = require('../lib/request')

module.exports = favorites

function favorites(options) {
  options = options || {}
  var offset = options.offset || 0
  var limit = options.limit || 100

  return request({
    method: 'get',
    host: 'https://api.soundcloud.com',
    path: '/users/53101589/favorites.json',
    data: {
      limit, offset,
      client_id: lib.CLIENT_ID
    }
  })
}
