module.exports = function omit(obj, ...props) {
  var child = Object.assign({}, obj)

  for (let key of props) {
    delete child[key]
  }

  return child
}
