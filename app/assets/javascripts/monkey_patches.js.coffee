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

  dasherize: (camel_case_or_underscore_word) ->
    Inflections.underscore(camel_case_or_underscore_word).replace('_', '-')

for name, fn of Inflections
  ((fn) -> String::[name] = -> fn(this, arguments...))(fn)

HTMLCanvasElement::blur = (radius, options = {}) ->
  top    = options.top    or 0
  left   = options.left   or 0
  width  = options.width  or this.width
  height = options.height or this.height
  src    = options.src
  done   = options.done

  if src
    size              = Math.max(width, height)
    image             = new Image()
    image.crossOrigin = "anonymous" unless /^data:/.test(src)
    image.onload      = =>
      console.log 'drawing image and blurring'
      this.getContext('2d').drawImage(image, left, top, size, size)
      stackBlurCanvasRGB(this, left, top, width, height, radius)
      done?(this)
    image.src = src
    this
  else
    console.log 'just blurring'
    stackBlurCanvasRGB(this, left, top, width, height, radius)
