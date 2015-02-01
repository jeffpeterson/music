import {css} from '../lib'
import React from 'react/addons'


export default React.createClass({
  displayName: 'Scroller',

  getDefaultProps() {
    return {
      onUpdate() {},
      loadNextPage() {},
    }
  },

  getInitialState() {
    return {
      scrollY: 0
    }
  },

  render() {
    let bodyStyle = {
      transform: `translate3d(0, ${-this.state.scrollY}px, 0)`
    }

    return (
      <div className='Scroller' onWheel={this.handleWheel}>
        <div className='Scroller-body' style={bodyStyle}>
          {this.props.children}
        </div>
      </div>
    )
  },

  handleScroll() {
    var timestamp = 0
    var ptimestamp = 0
    var waitingForFrame, pixelDelta, milliDelta, pixelsPerMilli, millisToBottom

    var distanceToBottom = 0
    var pdistanceToBottom = 0

    var onFrame = () => {
      waitingForFrame = false
      pixelDelta = pdistanceToBottom - distanceToBottom
      milliDelta = timestamp - ptimestamp
      pixelsPerMilli = pixelDelta / milliDelta
      millisToBottom = distanceToBottom / pixelsPerMilli

      this.props.onUpdate(pixelsPerMilli)

      if (millisToBottom < 400 && millisToBottom >= 0) {
        this.props.loadNextPage()
      }
    }

    return e => {
      var t = e.target

      pdistanceToBottom = distanceToBottom
      ptimestamp = timestamp
      timestamp = e.timeStamp
      distanceToBottom = t.scrollHeight - this.state.scrollY - t.clientHeight

      if (!waitingForFrame) {
        waitingForFrame = true
        requestAnimationFrame(onFrame)
      }
    }
  },

  handleWheel(e) {
    e.preventDefault()
    console.log(e.deltaY)
    this.setState({scrollY: Math.max(0, this.state.scrollY + e.deltaY)})
    this.handleScroll()
  }
})

css('.Scroller', {
  flex: '1 1 auto',
  display: 'flex',
  alignItems: 'stretch',
  flexDirection: 'column',
  overflow: 'hidden',
  paddingTop: 150,
})


// state:
// {
//   scrollY: 123,
//   time: 1234538383.383,
// }

function needsNextPage(pstate, state, expectedResponseTime) {
}
