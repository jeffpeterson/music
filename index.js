require('6to5/polyfill')

var React = require('react/addons')
var App = React.createFactory(require('./components/App'))

React.render(App(), window.mount)
