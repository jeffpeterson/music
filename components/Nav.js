import {css} from 'lib'
import Base from './Base'

export default class Nav extends Base {
  render() {
    return (
      <div className="Nav">
        <div className="Ratio"></div>
        {this.props.children}
      </div>
    )
  }
}

export class Item extends Base {
  render() {
    return (
      <div className={`Nav_Item ${this.props.selected && 'Nav_Item-selected'}`}>
        {this.props.children}
      </div>
    )
  }
}

Nav.Item = Item

css('.Nav', {
  display: 'flex',
  alignItems: 'flex-end',
  paddingBottom: 10,
  position: 'absolute',
  bottom: 0,
  right: 0,
  left: 0,
})

css({
  '.Nav_Item': {
    display: 'inline-block',
    textTransform: 'uppercase',
    fontSize: 20,
    padding: '0 10px',
    lineHeight: '1',
    cursor: 'pointer',
    verticalAlign: 'baseline',
    transition: 'all 200ms ease-in-out',
  },

  '.Nav_Item:hover': {
    // fontWeight: 'bold',
    // fontSize: 30,
  },

  '.Nav_Item-selected, .Nav_Item-selected:hover': {
    fontSize: 40,
    fontWeight: 'bold',
    padding: '0 20px',
  }
})
