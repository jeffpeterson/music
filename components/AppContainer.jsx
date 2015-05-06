import Chloroform from 'chloroform'
import lib from 'lib'
import client from 'client'
import {key} from 'lib/keyboard'
import {css} from 'lib/css'
import {rgb} from 'lib/color'

let ctx = lib.ctx()

export class AppContainer extends BaseContainer {
  componentDidMount() {
    this.loadFirstPage()
    this.changeColorsToMatchTrack(this.currentTrack())
    window.addEventListener('unload', this.store)
    window.addEventListener('keydown', this.onKeyDown)
  }

  render() {
    let props = {}

    return (
      <App {...props} />
    )
  }
}
