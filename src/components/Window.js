import {Component} from 'react'
import {forEachObjIndexed} from 'ramda'

export default class Window extends Component {
  static eventNames = {
    unload: 'onUnload',
    load: 'onLoad',
    resize: 'onResize',
    keydown: 'onKeyDown',
  }



  componentDidMount() {
    eachEvent((prop, name) => {
      let fn

      if (fn = this.props[prop]) {
        window.addEventListener(name, this.props.store)
      }
    })
  }

  componentWillUnmount() {
    eachEvent((prop, name) => {
      let fn

      if (fn = this.props[prop]) {
        window.removeEventListener(name, this.props.store)
      }
    })
  }

  render() {
    return null
  }
}

const eachEvent = forEachObjIndexed(Window.eventNames)
