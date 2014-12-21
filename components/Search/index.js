var React = require('react')
var input = React.DOM.input

module.exports = React.createClass({
  displayName: 'Search',

  handleChange: function(e) {
    this.props.setQuery(e.target.value)
  },

  render: function() {
    return input({
      className: 'Search',
      value: this.props.query,
      onChange: this.handleChange
    })
  }
})
