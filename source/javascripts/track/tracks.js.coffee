#= require track
class App.Tracks extends Backbone.Collection
  model: App.Track
  comparator: (m) -> - m.get("playCount")
  url: "getTracksInCollection"
  request: (options = {}) ->
    _.defaults options,
      sort: 'playCount'
      start: 0
      count: 40
      extras: 'playCount'
    return false if @current_request
    console.time @url
    @current_request = R.request
      method: @url
      content: options
      success: (response) =>
        setTimeout((=> @current_request = null), 500)
        @set response.result
        window.lastr = response.result

        console.timeEnd @url
        @save()
  save: ->
    localStorage.tracks = JSON.stringify @first(40)
