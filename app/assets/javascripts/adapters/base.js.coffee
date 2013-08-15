class App.Adapters.Base
  constructor: (options = {}) -> @initialize(arguments...)
  initialize:  (options = {}) -> this
  translate:   (type, mappings = {}) ->
