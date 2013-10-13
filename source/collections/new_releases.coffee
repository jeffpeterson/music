#= require ./albums

class App.Collections.NewReleases extends App.Collections.Albums
  method: 'getNewReleases'

  fetch: (options = {}) ->
    super _.defaults options
