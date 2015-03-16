import 'babel-core/polyfill'

import React from 'react/addons'
import {App} from 'components/App'

window.React = React
React.render(<App />, window.mount)
