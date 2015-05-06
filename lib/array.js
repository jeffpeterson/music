export function range(start, end, step = 1) {
  // (0, 3) -> [0, 1, 2]
  // (1, 4) -> [1, 2, 3]
  let arr = []

  for (let i = start; i < end; i += step) {
    arr.push(i)
  }

  return arr
}

export function rotate(arr, n) {
  // ([1,2,3], 1) -> [2,3,1]
  // ([1,2,3], 2) -> [3,1,2]
  n %= arr.length
  return arr.slice(n).concat(arr.slice(0, n))
}

export function fracture(arr, start, n) {
  // like slice, but each item has a fixed/deterministic
  // index in the array
  //
  // ([0,1,2,3], 0, 3) -> [0,1,2]
  // ([0,1,2,3], 1, 3) -> [3,1,2]

  return rotate(arr.slice(start, start + n), -start)
}
