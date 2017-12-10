module.exports = rotate

function rotate(array, n) {
  return array.slice(n).concat(array.slice(0, n))
}
