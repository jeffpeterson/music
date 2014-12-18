var React = require('react')
var div = React.DOM.div
var WaveForm = React.createFactory(require('../WaveForm'))
var Nav = React.createFactory(require('../Nav'))

module.exports = React.createClass({
  render: function() {
    return div({className: 'Header'},
      WaveForm({analyser: this.props.analyser})
    )
  }
})
