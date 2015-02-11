import {css, debug} from '../lib'
import React from 'react/addons'


export default React.createClass({
  displayName: 'Scroller',

  getDefaultProps() {
    return {
      onUpdate: null,
      loadNextPage: null,
    }
  },

  getInitialState() {
    return {
      scrollY: 0,
      time: performance.now(),
    }
  },

  componentDidUpdate(_, pstate) {
    return
    if (!this.props.loadNextPage) {
      return
    }

    let body = this.refs.body.getDOMNode()
    let height = body.scrollHeight - body.clientHeight

    if (isNextPageNeeded(pstate, this.state, height)) {
      this.props.loadNextPage()
    }
  },

  render() {
    let bodyStyle = {
      transform: `translate3d(0, ${-this.state.scrollY}px, 0)`
      // transform: `translate3d(0, ${-this.state.scrollY}px, 0) scale(${this.state.scrollY / -10000 + 1})`
      // transform: `translate3d(0, ${-this.state.scrollY}px, ${-this.state.scrollY}px) rotateY(${this.state.scrollY / 5}deg)`
    }

    return (
      <div className='Scroller' onWheel={this.handleWheel}>
        <div className='Scroller-body' ref="body" style={bodyStyle}>
          {this.props.children}
        </div>
      </div>
    )
  },

  handleWheel(e) {
    e.preventDefault()

    if (e.deltaY === 0) {
      return
    }

    this.setState({
      scrollY: Math.max(0, this.state.scrollY + e.deltaY),
      time: performance.now()
    })
  },
})

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
