import {css, translate, linearGradient} from 'lib/css'
import {Base} from './Base'
import {rgb, rgba} from 'lib/color'

export class Header extends Base {
  constructor(props) {
    super(props)

    this.state = {
      alpha: 0.9,
      hover: false,
    }
  }

  render() {
    let {colors, children} = this.props

    return (
      <div
        className="Header"
        style={this.style()}
        onMouseEnter={this.handleMouseEnter.bind(this)}
        onMouseOut={this.handleMouseOut.bind(this)}>

        {children}
      </div>
    )
  }

  style() {
    let {colors} = this.props
    let {hover} = this.state

    let alpha = hover ? 0.98 : 0.9
    let y = hover ? '150px' : 0

    return {
      backgroundColor: rgba(colors.background, alpha),
      color: rgb(colors[2]),
      // transform: translate(0, y, 0),
    }
  }

  handleMouseEnter() {
    this.setState({hover: true})
  }

  handleMouseOut() {
    this.setState({hover: false})
  }
}

css('.Header', {
  transition: 'background-color 300ms, transform 300ms',
  zIndex: 1,
  display: 'flex',
  height: 150,
  position: 'absolute',
  top: 0,
  left: 0,
  right: 0,
})
