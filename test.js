let babel = require('babel')
let fs = require('fs')
let filenames = process.argv.slice(2)


filenames.sort().map(filename => {
  fs.readFile(filename, (err, contents) => {
    testFile(filename, contents)
  })
})

function testFile(filename, contents) {
  let mod = require(filename)

  try {
    extractFunctions(contents).forEach(fun => {
      testFunction(mod[fun.name], fun)
    })
  } catch (e) {
    log(red(`FAIL: ${filename}`))
    log(red(e.message))
  }
}

function testFunction(fn, {sig, name, cases}) {
  log()
  cases.forEach(c => {
    testCase(fn, c)
  })
}

function testCase(fn, [args, expected]) {
  args = trim(args)
  let actual = eval(babel.transform(`fn(${args})`).code)
  let actualStr = JSON.stringify(actual)
  let expectedStr = JSON.stringify(eval(`(${expected})`))

  if (actualStr === expectedStr) {
    log(green(`  ${fn.name}(${args}) -> ${actualStr}`))
  } else {
    throw new Error(`${fn.name}(${args}) -> ${actualStr} expected ${expectedStr}`)
  }
}

let rx = /export function +((\w+).+) {\n((?:^ *\/\/.*\n)+)/gm
function extractFunctions(contents) {
  return matches(rx, contents)
  .map(([sig, name, rest]) => {
    return {
      sig,
      name,
      cases: matches(/\/\/ (.+) -> (.+)/g, rest)
    }
  })
}

function matches(rx, str) {
  str = str.toString()
  let ms = []
  let m
  while (m = rx.exec(str)) {
    ms.push(m.slice(1))
  }
  return ms
}

function green(...strs) { return strs.map(color(32)) }
function   red(...strs) { return strs.map(color(31)) }

function color(n) {
  return s => "\u001b[" + n + "m" + s + "\u001b[0m"
}

function log(...strs) {
  process.stdout.write(strs.join(' ') + "\n")
  return strs[0]
}

function trim(str) {
  return deparen(strip(str))
}

function deparen(str) {
  return str[0] === "(" ? str.replace(/^\(|\)$/g, '') : str
}

function strip(str) {
  return str.replace(/^ +| +$/g, '')
}
