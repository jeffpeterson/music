import {css, translate} from 'lib/css'
import Base from './Base'

export default class GridItem extends Base {
  render() {
    let {children} = this.props

    return (
      <div className="GridItem Ratio">{children}</div>
    )
  }
}

css({
  '.GridItem': {
    overflow: 'hidden',
    float: 'left',
    position: 'relative',
  },

  '.GridItem::before': {
    display: 'block',
    content: "''",
    paddingTop: '100%'
  }
})
