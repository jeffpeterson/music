import {css, translate} from 'lib/css'
import {Base} from './Base'

export class GridItem extends Base {
  constructor(props) {
    super(props)
  }

  render() {
    let {size, x, y, children} = this.props

    var style = {
      transform: translate(x * size, y * size, 0),
      width: size,
      height: size,
    }

    return (
      <div className="GridItem" style={style}>{children}</div>
    )
  }
}

css('.GridItem', {
  position: 'absolute',
  transition: '400ms'
})
