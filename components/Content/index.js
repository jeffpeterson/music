var React = require('react')
var div = React.DOM.div
var Grid = React.createFactory(require('../Grid'))
var Queue = React.createFactory(require('../Queue'))
var Scroller = React.createFactory(require('../Scroller'))

module.exports = React.createClass({
  render: function() {
    return div({className: 'Content'},
      Queue(),
      Scroller({}, Grid({play: this.props.play}))
    )
  }
})
