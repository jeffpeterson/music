window.App or= {}
App.store or= (store = {})

store.localStorage = window.localStorage
store.whiteList    = {}
store.memo         = {}
store.changed      = {}

store.set = (key, value) ->
  unless value?
    store.set(k, v) for k, v of key
    return

  store.changed[key] = true
  store.memo[key] = value
  store.commit()

store.get = (key, default_value = null) ->
  store.memo[key] or= (JSON.parse(localStorage["v#{App.version}/#{key}"] or null) or default_value)

store.commitNow = ->
  keys = Object.keys(store.changed)
  App.debug "commiting #{keys.join(', ')} to store."
  try
    for key in keys
      store.localStorage["v#{App.version}/#{key}"] = JSON.stringify(store.memo[key])
      delete store.changed[key]
  catch error
    store.prune()
    App.debug "ERROR:", error

store.commit = _.debounce store.commitNow, 1000

store.keep = (key) ->
  store.whiteList[key] = true

store.prune = ->
  # delete non-whitelisted keys

store.clear = ->
  regex = new RegExp("^v#{App.version}/")
  for key, value of store.localStorage when not regex.test(key)
    delete store.localStorage[key]

# App.memo = (key, property, fn) ->
#   cached_object = App.get_local(key, {})
#   if fn? and not cached_object[property]
#     cached_object[property] = fn?()
#     App.set_local(key, cached_object)
#   cached_object[property]

