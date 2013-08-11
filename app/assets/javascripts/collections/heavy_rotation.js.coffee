#= require ./albums

class App.Collections.HeavyRotation extends App.Collections.Albums
  comparator: 'hits'
  method:     'getHeavyRotation'

  fetch: (options = {}) ->
    unless R?.ready?()
      App.once 'rdio:ready', => @fetch(options)
      return

    super _.defaults options, type: 'albums', user: R.currentUser.get('key'), friends: true

