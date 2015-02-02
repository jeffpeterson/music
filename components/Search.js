import {css} from '../lib'
import React from 'react/addons'

export default React.createClass({
  displayName: 'Search',

  getInitialState() {
    return {
      query: this.props.query
    }
  },

  render() {
    return <input className="Search" value={this.state.query} onChange={this.handleChange} onKeyDown={this.handleKeyDown } />
  },

  handleChange(e) {
    this.props.setActive(!!e.target.value)

    this.setState({ query: e.target.value })
  },

  sendQuery(query) {
    this.props.setQuery(this.state.query)
  },

  handleKeyDown(e) {
    switch (e.which) {
    case 13:
      this.sendQuery()
    }
  }
})

css('.Search', {
  flex: '1 0 50%',
  background: 'none',
  border: 'none',
  color: 'inherit',
  display: 'flex',
  fontSize: 80,
  lineHeight: 150,
  outline: 'none',
  padding: '0 20px',
})
