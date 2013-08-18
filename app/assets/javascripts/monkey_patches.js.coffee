Inflections =
  underscore: (camelized_word) ->
    camelized_word.replace('-', '_').replace(/([a-z])([A-Z])/g, (match, lower, upper) -> "#{lower}_#{upper}").toLowerCase()

  camelize: (underscored_word) ->
    underscored_word.replace(/(?:^|_|-)([a-z])/g, (match, start) -> start.toUpperCase())

  singularize: (plural_word) ->
    plural_word.replace(/s$/, '')

  pluralize: (singular_word) ->
    singular_word + 's'

for name, fn of Inflections
  ((fn) -> String::[name] = -> fn(this))(fn)
