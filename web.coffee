http = require "http"
express = require "express"
tropo = require "tropo-webapi"

expressServer = express()
expressServer.configure ->

	expressServer.use express.compress()
	expressServer.use express.bodyParser()
	expressServer.use expressServer.router

server = http.createServer expressServer

server.get "/voice-inbound", (req, res, next) ->
	ret = new tropo.TropoWebAPI
	ret.say "Hello, 410."
	res.send tropo.TropoJSON ret

server.get "/text-inbound", (req, res, next) ->

server.listen (port = process.env.PORT ? 5080), -> console.log "Listening on port #{port}"