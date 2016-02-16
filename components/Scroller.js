import React from 'react'

import {now} from 'lib/time'
import {css, debug} from 'lib'
import Base from './Base'

export default class Scroller extends Base {
  constructor(props) {
    super(props)

    this.state = {
      scrollY: 0,
      time: now(),
      scrollDelta: 0,
    }
  }

  componentDidUpdate(_, pstate) {
    return
    if (!this.props.loadNextPage) {
      return
    }

    let body = React.findDOMNode(this.refs.body)
    let height = body.scrollHeight - body.clientHeight

    if (isNextPageNeeded(pstate, this.state, height)) {
      this.props.loadNextPage()
    }
  }

  render() {
    let bodyStyle = {
      transform: `translate3d(0, ${-this.state.scrollY}px, 0)`
      // transform: `translate3d(0, ${-this.state.scrollY}px, 0) scale(${this.state.scrollDelta / -100 + 1})`
      // transform: `translate3d(0, ${-this.state.scrollY}px, ${-this.state.scrollY}px) rotateY(${this.state.scrollY / 5}deg)`
    }

    return (
      <div className='Scroller' onWheel={this.handleWheel()}>
        <div className='Scroller-body' ref="body" style={bodyStyle}>
          {this.props.children}
        </div>
      </div>
    )
  }

  handleWheel() {
    return (e) => {
      e.preventDefault()

      if (e.deltaY === 0) {
        return
      }

      var scrollY = Math.max(0, this.state.scrollY + e.deltaY)

      this.setState({
        scrollY: scrollY,
        scrollDelta: scrollY - this.state.scrollY,
        time: now()
      })
    }
  }
}

Scroller.defaultProps = {
  onUpdate: null,
  loadNextPage: null,
}

css('.Scroller', {
  flex: '1 1 auto',
  display: 'flex',
  alignItems: 'stretch',
  flexDirection: 'column',
  overflow: 'hidden',
  transformOrigin: 'center center',
  perspective: '1000px',
  paddingTop: 150,
})

css('.Scroller-body', {

})

function isNextPageNeeded(pstate, state, height, expectedResponseTime = 400) {
  return (pixelsPerMilli(pstate, state) * expectedResponseTime + state.scrollY) > height
}

function pixelsPerMilli(pstate, state) {
  return (state.scrollY - pstate.scrollY) / (state.time - pstate.time)
}
