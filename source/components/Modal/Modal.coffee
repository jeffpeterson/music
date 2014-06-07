Component.new 'Modal',
  in: ->
    @$el.css opacity: 0

    @$(".modal-inner").css
      scale: 0.5

    @$(".modal-inner").transit
      scale: 1,
      duration: 100

    @$el.transit
      opacity: 1,
      duration: 100

  out: (complete) ->
    @$(".modal-inner").transit
      scale: 0.5

    @$el.transit
      opacity: 0,
      duration: 100,
      complete: complete
