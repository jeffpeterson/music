let perf = window.performance

let _now = (perf && perf.now) ?
  perf.now.bind(perf) : Date.now.bind(Date)

export function now() {
  return _now()
}
