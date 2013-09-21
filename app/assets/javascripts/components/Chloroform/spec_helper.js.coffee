#= require console.image
#= require underscore
#= require chloroform

before ->
  logColor = (color) ->
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
    @assert Chloroform::isDark(@_obj),
      "expected #{@_obj} to be dark",
      "expected #{@_obj} to not be dark"

  chai.Assertion.addMethod 'differFrom', (otherColor) ->
    logColor(@_obj)
    logColor(otherColor)

    @assert Chloroform::areDiffering(@_obj, otherColor),
      "expected #{@_obj} to differ from #{otherColor}",
      "expected #{@_obj} not to differ from #{otherColor}"

  chai.Assertion.addMethod 'about', (expected, precision = 1) ->
    for n, i in expected
      @assert Math.abs(@_obj[i] - n) <= precision,
        "expected #{@_obj} to be about #{expected}",
        "expected #{@_obj} to not be about #{expected}"

  chai.Assertion.addMethod 'contrast', (otherColor) ->
    @assert Chloroform::areContrasting(@_obj, otherColor),
      "expected #{@_obj} to contrast #{otherColor}",
      "expected #{@_obj} not to contrast #{otherColor}"

  chai.Assertion.addMethod 'findColors', (colors...) ->
    cf = new Chloroform
    new chai.Assertion(cf.findColors(@_obj)).to.deep.equal(colors)
