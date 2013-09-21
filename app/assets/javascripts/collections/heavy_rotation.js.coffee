#= require ./albums

class App.Collections.HeavyRotation extends App.Collections.Albums
  comparator: 'hits'
  method:     'getHeavyRotation'

  fetch: (options = {}) ->
    super _.defaults options, type: 'albums', user: R.currentUser.get('key'), friends: true

