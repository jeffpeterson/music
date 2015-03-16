import React from 'react'

import {Base} from './Base'

export class ScrollTracker extends Base {
  constructor(props) {
    super(props)

    this.handleWheel = this.handleWheel.bind(this)
  }

  shouldComponentUpdate(nextProps) {
    return this.props.scrollY !== nextProps.scrollY
  }

  render() {
    let {children} = this.props

    let style = {
      width: '100%',
      height: '100%',
    }

    return (
      <div style={style} onWheel={this.handleWheel}>
        {children}
      </div>
    )
  }

  handleWheel(e) {
    e.preventDefault()

    if (e.deltaY === 0) {
      return
    }

    this.props.onChange(this.props.scrollY + e.deltaY)
  }
}

ScrollTracker.defaultProps = {
  onChange() {},
  scrollY: 0,
}
