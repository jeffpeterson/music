Component.new 'StateMachine',
  state: []
  states: {
    signedIn:
      signedOut: ->
        $el.removeClass('signed-in').addClass('signed-out')

    signedOut:
      signedIn: ->
        $el.removeClass('signed-out').addClass('signed-in')

  }
