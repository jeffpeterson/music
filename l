#!/usr/bin/env coffee

global.L = require('./source/libs/L.js').L
require './source/monkey_patches.coffee'

exec = require('child_process').exec
fs    = require 'fs'
puts  = console.log
tasks = {}

task = (name, desc, action) ->
  [desc, action] = [action, desc] unless action
  action.desc = desc
  tasks[name] = action

desc = (text) ->
  arguments.callee.caller.desc = text

# option '-p', '--port NUMBER',     'port to listen on'
# option '-a', '--address ADDRESS', 'address to listen at'
# option '-S', '--socket PATH',     'unix socket to bind to'
# option '-F', '--fake',            'disable APIs and use fake data'

task 'serve', ->
  require('./source/Server/Server.coffee').serve()

task 'install', ->
  puts "do something here"

task 'build', 'build the site for production', ->

task 'push', 'push the site to production', ->

task 'spec', 'run the server specs', ->
  require('./source/Server/Server.coffee').spec()

task 'component:new', 'create a new component', (fullName) ->
  return puts "component:new NAME" unless fullName
  parts = fullName.split('.')
  path  = "./source/components/#{parts.join('/')}"
  name  = parts.slice(-1)
  parent = ['Component'].concat(parts.slice(0, -1)).join('.')

  if fs.existsSync(path)
    return puts "#{fullName} already exists!"

  exec "mkdir -p #{path}"
  exec "echo \"#{parent}.new '#{name}', \n  initialize: ->\" > #{path}/#{name}.coffee"
  exec "echo \".#{parts.join('_').dasherize()}\" > #{path}/#{name}.styl"
  exec "touch #{path}/#{name}.hamlc"

task 'component:convert', 'convert a view to a component', (viewName, compName) ->
  return puts "component:convert view_name component_name" unless viewName and compName

  tasks['component:new'](compName)

  exec ""

do ->
  args = process.argv
  name = args[2]

  if task = tasks[name]
    task.apply(task, args.slice(3))
  else
    console.log "Tasks:"

    for name, action of tasks
      console.log(
        '   ',
        name,
        new Array(20).join(' ').slice(name.length),
        action.desc or '',
        "\n")
