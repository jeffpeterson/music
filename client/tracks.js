var request = require('../lib/request')

module.exports = tracks

function tracks(options) {
  options = options || {}
  var q = options.query
  var offset = options.from || 0
  var limit = options.limit || 100

  return request({
    method: 'get',
    host: 'https://api.soundcloud.com',
    path: '/tracks.json',
    data: {
      limit, offset, q,
      client_id: '6da9f906b6827ba161b90585f4dd3726'
    }
  })
}
