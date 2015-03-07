import React from 'react'

export class Base extends React.Component {
  constructor(...o) {
    super(...o)

    this.state = this.state || this.constructor.state()
  }

  static state() {
  }
}
