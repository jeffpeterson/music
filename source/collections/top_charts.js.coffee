#= require ./albums

class App.Collections.TopCharts extends App.Collections.Albums
  method: 'getTopCharts'
  comparator: 'playCount'

  fetch: (options = {}) ->
    super _.defaults options, type: 'albums', extras: ['playCount']
