export function rgba(color, alpha) {
  return `rgba(${join(color)}, ${alpha})`
}

export function rgb(color) {
  return `rgb(${join(color)})`
}

export function mix(c1, c2, ratio) {
  // '0,0,0', '255,255,255', 0.8 -> '204,204,204'

  return join(add(mult(c1, 1 - ratio), mult(c2, ratio)))
}

function mult(rgb, x) {
  return split(rgb).map(p => p * x)
}

function add(c1, c2) {
  let rgb1 = split(c1)
  let rgb2 = split(c2)

  return rgb1.map((p, i) => p + rgb2[i])
}

function split(c) {
  switch (typeof c) {
    case "string": return c.split(',')
    case "undefined": return []
  }

  return c
}

function join(c) {
  switch (typeof c) {
    case "string":
      return c
    case "undefined":
      return "0,0,0"
  }

  return norm(c).join(',')
}

function norm(c) {
  return c.map(p => Math.min(255, Math.max(0, p|0)))
}
