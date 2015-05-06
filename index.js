import 'babel-core/polyfill'

import React from 'react'
import {App} from 'components/App'
import {reactor} from 'core/reactor'

reactor(state => {
  React.render(<App {...state} />, window.mount)
})
