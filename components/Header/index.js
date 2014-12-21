var React = require('react')
var div = React.DOM.div
var WaveForm = React.createFactory(require('../WaveForm'))
var Search = React.createFactory(require('../Search'))

module.exports = React.createClass({
  displayName: 'Header',

  getInitialState: function() {
    return {
      searchIsActive: !!this.props.query
    }
  },

  render: function() {
    return div({className: 'Header'},
      WaveForm({
        player: this.props.player,
        currentTrack: this.props.currentTrack,
        backgroundRgb: this.props.colors.background,
        lineRgb: this.props.colors[0],
        isDimmed: this.state.searchIsActive
      }),
      Search({
        query: this.props.query,
        setQuery: this.props.setQuery,
        color: this.props.colors[1],
        setActive: this.setSearchActive
      })
    )
  },

  setSearchActive: function(isActive) {
    this.setState({
      searchIsActive: isActive
    })
  }
})
