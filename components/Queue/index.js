var React = require('react')
var div = React.DOM.div

module.exports = React.createClass({
  render: function() {
    return div({className: 'Queue Ratio'}, 'Queue')
  }
})
