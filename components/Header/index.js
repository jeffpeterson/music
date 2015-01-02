var React = require('react/addons')
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
    var style = {
      backgroundColor: `rgba(${this.props.colors.background}, 0.9)`
    }

    return div({style, className: 'Header'},
      WaveForm({
        ctx: this.props.ctx,
        currentTrack: this.props.currentTrack,
        colors: this.props.colors,
        isDimmed: this.state.searchIsActive
      }),
      Search({
        query: this.props.query,
        setQuery: this.props.setQuery,
        color: this.props.colors[2],
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
