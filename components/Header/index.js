var React = require('react')
var Chloroform = require('../../vendor/chloroform')
var div = React.DOM.div
var WaveForm = React.createFactory(require('../WaveForm'))
var Search = React.createFactory(require('../Search'))

module.exports = React.createClass({
  displayName: 'Header',

  getInitialState: function() {
    return {
      colors: [],
      searchIsActive: !!this.props.query
    }
  },

  componentWillReceiveProps: function(props) {
    if (props.currentTrack !== this.props.currentTrack) {
      this.changeColorsToMatchTrack(props.currentTrack)
    }
  },

  render: function() {
    return div({className: 'Header'},
      WaveForm({
        player: this.props.player,
        currentTrack: this.props.currentTrack,
        backgroundRgb: this.state.colors.background,
        lineRgb: this.state.colors[0],
        isDimmed: this.state.searchIsActive
      }),
      Search({
        query: this.props.query,
        setQuery: this.props.setQuery,
        color: this.state.colors[1],
        setActive: this.setSearchActive
      })
    )
  },

  changeColorsToMatchTrack: function(track) {
    Chloroform.analyze(artUrl(track), function(colors) {
      this.setState({ colors: colors })
    }.bind(this))
  },

  setSearchActive: function(isActive) {
    this.setState({
      searchIsActive: isActive
    })
  }
})

function artUrl(track) {
  var url = track.artwork_url || track.user.avatar_url || ''
  return url.replace('-large', '-t500x500')
}

