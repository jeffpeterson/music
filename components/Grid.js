import {css} from 'lib'
import Base from './Base'
import GridItem from './GridItem'
import Scroller from './Scroller'

export default class Grid extends Base {
  render() {
    let {
      props: {children, loadNextPage}
    } = this

    let items = children.map(child => (
      <GridItem key={child.key}>{child}</GridItem>
    ))

    return (
      <Scroller loadNextPage={loadNextPage}>
        <div className="Grid">{items}</div>
      </Scroller>
    )
  }
}

css('.Grid', {
  transform: "translate3d(0,0,0)",
})
