import {css} from 'lib'
import Base from './Base'
import {rgb, rgba} from 'lib/color'

export default class Header extends Base {
  constructor(props) {
    super(props)

    this.state = {
      alpha: 0.9,
    }
  }

  render() {
    let {colors, children} = this.props

    return (
      <div
        className="Header"
        style={this.style()}
        onMouseEnter={this.mouseEnterHandler()}
        onMouseOut={this.mouseOutHandler()}>

        {children}
      </div>
    )
  }

  style() {
    let {colors} = this.props
    let {alpha} = this.state

    return {
      backgroundColor: rgba(colors.background, alpha),
      color: rgb(colors[2]),
    }
  }

  mouseEnterHandler() {
    return () => this.setState({alpha: 0.98})
  }

  mouseOutHandler() {
    return () => this.setState({alpha: 0.9})
  }
}

css('.Header', {
  transition: 'background-color 300ms',
  zIndex: 1,
  display: 'flex',
  height: 150,
  position: 'absolute',
  top: 0,
  left: 0,
  right: 0,
})
