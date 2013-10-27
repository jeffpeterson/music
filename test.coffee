cluster = require 'cluster'
http    = require 'http'
os      = require 'os'

console.log "START"

if cluster.isMaster
  for cpu, i in os.cpus()
    cluster.fork()
    console.log "forking", i

  cluster.on 'exit', (worker, code, signal) ->
    console.log 'worker', worker.process.pid, 'died'

else
  http.createServer((req, res) ->
    res.writeHead(200)
    res.end("hello world")
  ).listen(8765)

console.log "END"
