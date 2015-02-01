import {css} from '../lib'
import React from 'react/addons'
import WaveForm from './WaveForm'
import Search from './Search'

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

    return (
      <div className="Header" style={style}>
        <WaveForm ctx={this.props.ctx} currentTrack={this.props.currentTrack} colors={this.props.colors} isDimmed={this.state.searchIsActive} />
        <Search query={this.props.query} setQuery={this.props.setQuery} color={this.props.colors[2]} setActive={this.setSearchActive} />
      </div>
    )
  },

  setSearchActive: function(isActive) {
    this.setState({
      searchIsActive: isActive
    })
  }
})

css('.Header', {
  transform: 'translate3d(0,0,0)',
  zIndex: 1,
  display: 'flex',
  height: 150,
  position: 'absolute',
  top: 0,
  left: 0,
  right: 0,
})
