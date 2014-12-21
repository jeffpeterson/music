var React = require('react')
var div = React.DOM.div
var WaveForm = React.createFactory(require('../WaveForm'))
var Search = React.createFactory(require('../Search'))

module.exports = React.createClass({
  displayName: 'Header',
  render: function() {
    return div({className: 'Header'},
      WaveForm({player: this.props.player}),
      Search({query: this.props.query, setQuery: this.props.setQuery})
    )
  }
})
