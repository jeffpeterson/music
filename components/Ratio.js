import {css} from '../lib'

css('.Ratio', {
  width: '50vw',
})

css.media('min-width: 600px', css => {
  css('.Ratio', {
    width: '33.3333vw',
  })
})

css.media('min-width: 1000px', css => {
  // 1/4

  css('.Ratio', {
    width: '25vw',
  })
})

css.media('min-width: 1300px', css => {
  // 1/5

  css('.Ratio', {
    width: '20vw',
  })
})

css.media('min-width: 1600px', css => {
  // 1/6

  css('.Ratio', {
    width: '16.6667vw',
  })
})
