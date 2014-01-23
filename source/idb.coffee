idb.migrate
  1: (m) ->
    m('tracks').create

idb('tracks').get(123) ->
  model.track = this

