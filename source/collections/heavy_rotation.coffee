#= require ./albums

class App.Collections.HeavyRotation extends App.Collections.Albums
  comparator: 'hits'
  method:     'getHeavyRotation'

  fetch: (options = {}) ->
    super _.defaults(options, type: 'albums', user: App.store.get('current_user').key, friends: true)

