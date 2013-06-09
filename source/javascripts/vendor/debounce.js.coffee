timeouts = {}
window.debounce = (name, delay, callback) ->
  clearTimeout timeouts[name]
  timeouts[name] = setTimeout callback, delay
