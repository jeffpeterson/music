module.exports = logger

var disabled = {}
var maxLength = 3

function logger(kind) {

  kind = kind.toUpperCase()
  maxLength = Math.max(maxLength, kind.length)

  return function log(tag, x, ...xs) {
    if (!disabled[kind]) {
      console.log('%' + maxLength + 's |', kind, tag, x, ...xs)
    }

    return x
  }
}

logger.disable = function disable(kind) {
  disabled[kind] = true
}

logger.enable = function enable(kind) {
  disabled[kind] = false
}
