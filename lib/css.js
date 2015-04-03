export default css

export function css(selector, props) {
  if (typeof selector === 'object') {
    for (let k in selector) {
      css(k, selector[k])
    }
    return
  }

  insertStyleString(cssToString(selector, props), selector)
}

export function translate(x, y, z) {
  return ` translate3d(${unitize(x)}, ${unitize(y)}, ${unitize(z)}) `
}

export function linearGradient(dir, ...colors) {
  return ` linear-gradient(${dir}, ${colors.join(',')}) `
}

function unitize(n) {
  return typeof n === "number" ? n + 'px' : n
}

css.media = (mediaSelector, fn) => {
  let body = ""
  function nestedCss(selector, props) {
    body += cssToString(selector, props)
  }

  insertStyleString(wrapWithMediaSelector(mediaSelector, fn(nestedCss) || body), mediaSelector)
}

function insertStyleString(str, cacheKey) {
  styleElement(cacheKey).innerText = str
}

function cssToString(selector, props) {
  return wrapWithSelector(selector, propsToString(props))
}

function wrapWithMediaSelector(mediaSelector, body) {
  if (mediaSelector) {
    return wrapWithSelector('@media (' + mediaSelector + ')', body)
  } else {
    return body
  }
}

function wrapWithSelector(selector, body) {
  if (selector) {
    return selector + '{' + body + '}'
  } else {
    return body
  }
}

function propsToString(props) {
  return Object.keys(props)
  .map(prop => dasherize(prop) + ':' + reifyValue(prop, props[prop]))
  .join(';')
}

function reifyValue(prop, value) {
  switch (prop) {
    case 'opacity':
    case 'fontWeight':
    case 'zIndex': return value;
  }

  switch (value) {
    case 0: return 0;
  }

  switch (typeof value) {
    case 'number':
      return value + 'px'
  }

  return value
}

function dasherize(camel) {
  return camel.replace(/(.)(?=[A-Z])/g, '$1-').toLowerCase()
}

let styleElementCache = {}

function styleElement(cacheKey) {
  if (!cacheKey) {
    return createStyleElement()
  }

  let cached = styleElementCache[cacheKey]

  if (cached) {
    return cached
  } else {
    return styleElementCache[cacheKey] = createStyleElement()
  }
}

function createStyleElement() {
  let style = document.createElement('style')
  document.body.appendChild(style)
  return style
}
