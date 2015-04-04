import React from 'react'
import Immutable from 'immutable'
import {shallowEqual} from 'lib/shallowEqual'

export class Base extends React.Component {
  shouldComponentUpdate(nprops, nstate) {
    return shallowCompare(this, nprops, nstate)
  }

  setInState(keyPath, fn) {
    this.replaceState(this.state.setIn(keyPath, fn))
  }

  frame(fn) {
    let waitingForFrame = false

    return () => {
      if (waitingForFrame) {
        return
      }

      waitingForFrame = true

      requestAnimationFrame(ts => {
        waitingForFrame = false
        fn.call(this, ts)
      })
    }
  }
}

function shallowCompare(instance, nextProps, nextState) {
  return (
    !shallowEqual(instance.props, nextProps) ||
    !shallowEqual(instance.state, nextState)
  )
}
