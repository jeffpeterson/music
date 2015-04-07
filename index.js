import 'babel-core/polyfill'

import React from 'react'
import {App} from 'components/App'
import {reactor} from 'core/reactor'

React.render(<App />, window.mount)

// reactor(state => {
//   React.render(<App {...state} />, window.mount)
// })
