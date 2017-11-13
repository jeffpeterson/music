import {findDOMNode} from 'react-dom'

import {css} from 'lib'
import {key} from 'lib/keyboard'
import Base from './Base'

export default class Search extends Base {
  constructor(props) {
    super(props)

    this.onChange = this.onChange.bind(this)
    this.onKeyDown = this.onKeyDown.bind(this)
  }

  render() {
    let {
      onChange,
      onKeyDown,
      props: {query}
    } = this

    return <input
      className="Search"
      value={query}
      placeholder="search..."
      onChange={onChange}
      onKeyDown={onKeyDown} />
  }

  onChange(e) {
    this.props.onChange(e.target.value)
  }

  handleReturn() {
    this.props.onConfirm()
  }

  onKeyDown(e) {
    e.stopPropagation()

    switch (key(e.which)) {
    case 'return':
      this.handleReturn(e)
    case 'esc':
      findDOMNode(this).blur()
    }
  }
}

Search.defaultProps = {
  onChange() {},
  onConfirm() {},
  query: '',
}

css({
  ".Search": {
    flex: '1 0 50%',
    background: 'none',
    border: 'none',
    color: 'inherit',
    display: 'flex',
    fontSize: 80,
    lineHeight: 150,
    outline: 'none',
    padding: '0 20px',
    transition: 'all 300ms ease-in-out',
  },

  ".Search::placeholder": {
    opacity: '0',
    color: 'inherit',
    transition: 'all 300ms ease-in-out',
  },

  ".Search:hover::placeholder": {
    opacity: '0.9'
  },

  ".Search:focus::placeholder": {
    opacity: '0.5'
  },
})
