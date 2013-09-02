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
    @assert Chloroform::isDark(@Obj),
      "expected #{@Obj} to be dark",
      "expected #{@Obj} to not be dark"

  chai.Assertion.addMethod 'differFrom', (otherColor) ->
    logColor(@Obj)
    logColor(otherColor)

    @assert Chloroform::areDiffering(@Obj, otherColor),
      "expected #{@Obj} to differ from #{otherColor}",
      "expected #{@Obj} not to differ from #{otherColor}"

  chai.Assertion.addMethod 'about', (expected, precision = 1) ->
    for n, i in expected
      @assert Math.abs(@Obj[i] - n) <= precision,
        "expected #{@Obj} to be about #{expected}",
        "expected #{@Obj} to not be about #{expected}"

  chai.Assertion.addMethod 'contrast', (otherColor) ->
    @assert Chloroform::areContrasting(@Obj, otherColor),
      "expected #{@Obj} to contrast #{otherColor}",
      "expected #{@Obj} not to contrast #{otherColor}"

  chai.Assertion.addMethod 'findColors', (colors...) ->
    cf = new Chloroform
    new chai.Assertion(cf.findColors(@Obj)).to.deep.equal(colors)
