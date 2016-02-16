import 'babel-polyfill'

import React from 'react'
import {App} from 'components/App'

window.React = React
React.render(<App />, window.mount)
