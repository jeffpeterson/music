import React from 'react'

import {range, fracture, rotate} from 'lib/array'
import {css} from 'lib/css'
import {Base} from './Base'
import {GridItem} from './GridItem'

export class LazyGrid extends Base {
  shouldComponentUpdate() {
    return true
  }

  constructor(props) {
    super(props)

    this.state = {
      width: 1,
      height: 1,
      scroll: 0, // number of grid items
    }

    this.onResize = this.frame(this.onResize)
    this.onWheel = this.onWheel.bind(this)
  }

  componentDidMount() {
    this.onResize()
    window.addEventListener('resize', this.onResize)
  }

  componentDidUnmount() {
    window.removeEventListener('resize', this.onResize)
  }

  render() {
    return <div />
    return (
      <div className="LazyGrid" onWheelCapture={this.onWheel}>
        {this.renderGridItems()}
      </div>
    )
  }

  renderGridItems() {
    let {
      props: {itemSize, getter},
      state: {width, height, scroll},
    } = this

    let size = this.adjustedItemSize()
    let cols = this.colCount()
    let scrollRows = scroll / cols
    let rows = height / size + 2 | 0
    let count = rows * cols

    let first = (scrollRows | 0) * cols - count
    let last = first + count * 2

    return rotate(range(first, last), -first).map(i => {
      let rowIndex = i / cols | 0
      let x = (i % cols) * size
      let y = ((rowIndex - scrollRows) * size) | 0

      return (
        <GridItem {...{size, x, y}}>{getter(i)}</GridItem>
      )
    })
  }

  colCount() {
    return Math.max(1, this.state.width / this.props.itemSize | 0)
  }

  adjustedItemSize() {
    return this.state.width / this.colCount() | 0
  }

  onResize() {
    let width = React.findDOMNode(this).clientWidth
    let height = React.findDOMNode(this).clientHeight
    this.setState({width, height})
  }

  onWheel(e) {
    e.preventDefault()
    e.stopPropagation()

    let delta = e.deltaY / this.adjustedItemSize() * this.colCount()
    let scroll = Math.max(0, this.state.scroll + delta)
    this.setState({scroll})
  }
}

LazyGrid.defaultProps = {
  itemSize: 250,
}

css(".LazyGrid", {
  position: "relative",
  flexGrow: '1',
  overflow: 'visible',
  marginTop: 150,
})
