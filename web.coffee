http = require "http"
express = require "express"
tropo = require "tropo-webapi"

expressServer = express()
expressServer.configure ->

	expressServer.use express.compress()
	expressServer.use express.bodyParser()
	expressServer.use expressServer.router

expressServer.get "/voice-inbound", (req, res, next) ->
	ret = new tropo.TropoWebAPI
	ret.say "Hello, 410."
	res.json ret

expressServer.get "/text-inbound", (req, res, next) ->

server = http.createServer expressServer
server.listen (port = process.env.PORT ? 5080), -> console.log "Listening on port #{port}"