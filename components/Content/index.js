var React = require('react')
var div = React.DOM.div
var Header = React.createFactory(require('../Header'))
var Grid = React.createFactory(require('../Grid'))
var Scroller = React.createFactory(require('../Scroller'))

module.exports = React.createClass({
  render: function() {
    return div({className: 'Content'},
      Header({analyser: this.props.analyser}),
      Scroller({}, Grid({play: this.props.play}))
    )
  }
})
