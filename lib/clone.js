module.exports = function clone(obj, props) {
  var child = Object.create(obj)
  return Object.assign(child, props)
}
