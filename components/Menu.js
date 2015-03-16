import React from 'react'

import {css} from 'lib'
import {Base} from './Base'

export class Menu extends Base {
  render() {
    return (
      <div className="Menu" />
    )
  }
}

css('.Menu', {
  position: 'absolute',
  height: '100%',
  left: 0,
  right: 0,
  bottom: '100%',
  backgroundColor: 'white',
})
