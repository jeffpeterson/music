Inflections =
  underscore: (camelized_word) ->
    camelized_word.replace('-', '_').replace(/([a-z])([A-Z])/g, (match, lower, upper) -> "#{lower}_#{upper}").toLowerCase()

  camelize: (underscored_word, capitalize_first_letter = true) ->
    regex = /(?:_|-)([a-z])/g
    regex = /(?:^|_|-)([a-z])/g if capitalize_first_letter

    underscored_word.replace regex, (match, start) -> start.toUpperCase()

  singularize: (plural_word) ->
    plural_word.replace(/s$/, '')

  pluralize: (singular_word) ->
    singular_word + 's'

for name, fn of Inflections
  ((fn) -> String::[name] = -> fn(this, arguments...))(fn)
