import React from 'react'

import {css} from 'lib/css'
import {Base} from './Base'
import {LazyGrid} from './LazyGrid'

export class Grid extends Base {
  constructor(props) {
    super(props)

    this.itemGetter = this.itemGetter.bind(this)
  }

  render() {
    return (
      <LazyGrid getter={this.itemGetter} />
    )
  }
}
