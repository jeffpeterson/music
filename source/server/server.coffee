cluster = require 'cluster'
os      = require 'os'
coffee  = require 'coffee-script'

module.exports = (options) ->
  cluster.setupMaster
    exec: __dirname + '/Worker/Worker.coffee'

  cpus = os.cpus()

  console.log "Spawning #{cpus.length} workers..."

  for cpu, i in cpus
    cluster.fork(options)

  cluster.on 'exit', (worker, code, signal) ->
    console.log 'worker', worker.process.pid, 'died with code', code
    cluster.fork(options)

  cluster.on 'online', (worker) ->
    console.log 'worker', worker.process.pid, 'is online'
