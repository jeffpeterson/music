var React = require('react')
var input = React.DOM.input

module.exports = React.createClass({
  displayName: 'Search',

  getDefaultProps: function() {
    return {
      color: '255,255,255'
    }
  },

  render: function() {
    var style = {
      color: 'rgb(' + this.props.color + ')'
    }

    return input({
      style: style,
      className: 'Search',
      value: this.props.query,
      onChange: this.handleChange,
      onBlur: this.handleBlur,
      onFocus: this.handleFocus
    })
  },

  handleChange: function(e) {
    this.props.setQuery(e.target.value)
  },

  handleBlur: function(e) {
    this.props.setActive(!!e.target.value)
  },

  handleFocus: function(e) {
    this.props.setActive(true)
  }
})
