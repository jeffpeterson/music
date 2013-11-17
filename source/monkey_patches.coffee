Inflections =
  underscore:  L.underscore
  camelize:    L.camelize
  singularize: L.singularize
  pluralize:   L.pluralize
  dasherize:   L.dasherize

for name, fn of Inflections
  ((fn) -> String::[name] = -> fn(this, arguments...))(fn)


if typeof HTMLCanvasElement isnt "undefined"
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
