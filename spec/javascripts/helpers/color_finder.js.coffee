#= require console.image
#= require underscore
#= require color_finder

before ->
  log_color = (color) ->
    console.image swatch(color)

  swatch = (color) ->
    size   = 40
    canvas = document.createElement('canvas')
    canvas.width  = 300
    canvas.height = size
    ctx    = canvas.getContext('2d')
    ctx.fillStyle = "rgb(#{color})"
    ctx.fillRect(0,0,size,size)
    ctx.font     = '16px Arial'
    ctx.fillStyle = 'black'
    ctx.fillText(color, size + 10, size * 0.7)
    canvas.toDataURL()

  chai.Assertion.addProperty 'dark', ->
    @assert ColorFinder::is_dark(@_obj),
      "expected #{@_obj} to be dark",
      "expected #{@_obj} to not be dark"

  chai.Assertion.addMethod 'differ_from', (other_color) ->
    log_color(@_obj)
    log_color(other_color)

    @assert ColorFinder::are_differing(@_obj, other_color),
      "expected #{@_obj} to differ from #{other_color}",
      "expected #{@_obj} not to differ from #{other_color}"

  chai.Assertion.addMethod 'about', (expected, precision = 1) ->
    for n, i in expected
      @assert Math.abs(@_obj[i] - n) <= precision,
        "expected #{@_obj} to be about #{expected}",
        "expected #{@_obj} to not be about #{expected}"

  chai.Assertion.addMethod 'contrast', (other_color) ->
    @assert ColorFinder::are_contrasting(@_obj, other_color),
      "expected #{@_obj} to contrast #{other_color}",
      "expected #{@_obj} not to contrast #{other_color}"

  chai.Assertion.addMethod 'find_colors', (colors...) ->
    cf = new ColorFinder
    new chai.Assertion(cf.find_colors(@_obj)).to.deep.equal(colors)
