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
      client_id: '6da9f906b6827ba161b90585f4dd3726'
    }
  })
}
