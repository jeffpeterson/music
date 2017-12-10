module.exports = function only(obj, ...props) {
  var child = {}

  for (let key of props) {
    child[key] = obj[key]
  }

  return child
}
