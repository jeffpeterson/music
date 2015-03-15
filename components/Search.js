import {css} from 'lib'
import {Base} from './Base'

export class Search extends Base {
  render() {
    let {query} = this.props

    return <input
      className="Search"
      value={query}
      onChange={this.handleChange.bind(this)}
      onKeyDown={this.handleKeyDown.bind(this)} />
  }

  handleChange(e) {
    this.props.onChange(e.target.value)
  }

  handleReturn() {
    this.props.onConfirm()
  }

  handleKeyDown(e) {
    switch (e.which) {
    case 13:
      this.handleReturn(e)
    }
  }
}

Search.defaultProps = {
  onChange() {},
  onConfirm() {},
  query: '',
}

css('.Search', {
  flex: '1 0 50%',
  background: 'none',
  border: 'none',
  color: 'inherit',
  display: 'flex',
  fontSize: 80,
  lineHeight: 150,
  outline: 'none',
  padding: '0 20px',
})
