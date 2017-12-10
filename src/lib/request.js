function responseType(options) {
  return options.responseType || 'json'
}

function request(options) {
  var headers, method, url, xhr, data

  options = request.options(options)
  headers = request.headers(options)
  method = request.method(options)
  url = request.url(options)
  data = request.data(options)

  xhr = new XMLHttpRequest()
  // xhr.withCredentials = true

  xhr.open(method, url, 'async')
  xhr.responseType = responseType(options)

  for (var key in headers) {
    xhr.setRequestHeader(key, headers[key])
  }

  return new Promise(function(resolve, reject) {
    xhr.onreadystatechange = function onReadyStateChange() {
      if (xhr.readyState === xhr.DONE) {
        resolve(xhr)
      }
    }

    xhr.send(data)
  })
  .then(request.handleError)
  .then(function(xhr) {
    return xhr.response
  })
}

request.options = function options(_options) {
  if (!_options) {
    throw new TypeError('options is required')
  }

  return _options
}

request.method = function method(options) {
  if (!options.method) {
    throw new TypeError('options.method is required')
  }

  return options.method
}

request.host = function host(options) {
  if (!options.host) {
    throw new TypeError('options.host is required')
  }

  if (options.host.indexOf('//') < 0) {
    return '//' + options.host
  }

  return options.host
}

request.data = function data(options) {
  if (request.method(options) === 'get') {
    return
  }

  switch (typeof options.data) {
  case 'object':
    return JSON.stringify(options.data)
  case 'string':
    return options.data
  }
}

request.path = function path(options) {
  if (!options.path) {
    throw new TypeError('options.path is required')
  }

  return options.path
}

request.query = function query(options) {
  if (!options.data) {
    return ''
  }

  switch (request.method(options)) {
  case 'get':
    return '?' + Object.keys(options.data)
    .filter(function(key) {
      return options.data[key] != null
    })
    .map(function(key) {
      return encodeURIComponent(key) + '=' + encodeURIComponent(options.data[key])
    }).join('&')
  }

  return ''
}

request.url = function url(options) {
  if (options.url) {
    return options.url
  }

  var host = request.host(options)
  var path = request.path(options)
  var query = request.query(options)

  return host + path + query
}

request.headers = function headers(options) {
  var _headers = Object.create(request.defaults.headers)

  for (var key in options.headers) {
    _headers[key] = options.headers[key]
  }

  return _headers
}

request.handleError = function handleError(xhr) {
  if (xhr.status === 200) {
    return xhr
  }

  if (xhr.status === 0) {
    return Promise.reject(new Error('Unknown error. The response is likely missing CORS headers.'))
  }

  if (xhr.status === 403) {
    // we aren't signed in!
    // take some sort of action
  }

  return request.error(xhr);
}

request.error = function error(xhr) {
  var err;

  try {
    err = request.parse(xhr)
  } catch (e) {}

  if (err.error) {
    err = err.error
  }

  return Promise.reject(err)
}

request.defaults = {
  headers: {
    // 'Content-Type': 'application/json',
    // 'Accept': 'application/json'
  }
}

module.exports = request
