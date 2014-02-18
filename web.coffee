http = require "http"
express = require "express"
tropo = require "tropo-webapi"

expressServer = express()
expressServer.configure ->

	expressServer.use express.compress()
	expressServer.use express.bodyParser()
	expressServer.use expressServer.router

expressServer.post "/voice-inbound", (req, res, next) ->
	ret = new tropo.TropoWebAPI
	ret.say "   http://open410sesame.herokuapp.com/key9.wav"
	res.send tropo.TropoJSON ret

expressServer.get "/key9.wav", (req, res, next) ->
	res.sendfile "key9.wav"

# expressServer.post "/text-inbound", (req, res, next) ->

server = http.createServer expressServer
server.listen (port = process.env.PORT ? 5080), -> console.log "Listening on port #{port}"