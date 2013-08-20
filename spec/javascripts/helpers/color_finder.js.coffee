#= require console.image
#= require underscore
#= require color_finder

before ->
  chai.Assertion.addProperty 'dark', ->
    @assert ColorFinder::is_dark(@_obj),
      "expected #{@_obj} to be dark",
      "expected #{@_obj} to not be dark"

  chai.Assertion.addMethod 'differ_from', (other_color) ->
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
