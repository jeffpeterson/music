var React = require('react')
var div = React.DOM.div

function isNextPageRequired() {
}

module.exports = React.createClass({
  displayName: 'Scroller',

  getDefaultProps() {
    return {
      onUpdate() {},
      loadNextPage() {},
    }
  },

  render() {
    return div(
      {
        className: 'Scroller',
        onScroll: this.handleScroll(),
      },
      this.props.children
    )
  },

  handleScroll: function() {
    var timestamp = 0
    var ptimestamp = 0
    var waitingForFrame, pixelDelta, milliDelta, pixelsPerMilli, millisToBottom

    var distanceToBottom = 0
    var pdistanceToBottom = 0

    var onFrame = function onFrame() {
      waitingForFrame = false
      pixelDelta = pdistanceToBottom - distanceToBottom
      milliDelta = timestamp - ptimestamp
      pixelsPerMilli = pixelDelta / milliDelta
      millisToBottom = distanceToBottom / pixelsPerMilli

      this.props.onUpdate(pixelsPerMilli)

      if (millisToBottom < 400 && millisToBottom >= 0) {
        this.props.loadNextPage()
      }
    }.bind(this)

    return function(e) {
      var t = e.target

      pdistanceToBottom = distanceToBottom
      ptimestamp = timestamp
      timestamp = e.timeStamp
      distanceToBottom = t.scrollHeight - t.scrollTop - t.clientHeight

      if (!waitingForFrame) {
        waitingForFrame = true
        requestAnimationFrame(onFrame)
      }
    }
  },

})
