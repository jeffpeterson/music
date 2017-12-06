import 'babel-polyfill'

import React from 'react'
import {render} from 'react-dom'
import Immutable from 'immutable'
import installDevTools from 'immutable-devtools/src'

import App from 'components/App'
import reduce from 'reducers'
import {main} from 'lib/core'

import engines from 'engines'

window.React = React
installDevTools(Immutable)

main(reduce, engines, dispatch => state => {
  render(<App dispatch={dispatch} state={state} />, window.mount)
})
