http = require "http"
express = require "express"
tropo = require "tropo-webapi"
allowed = require "./whitelist.json"

expressServer = express()
expressServer.configure ->

	expressServer.use express.compress()
	expressServer.use express.bodyParser()
	expressServer.use expressServer.router

expressServer.post "/voice-inbound", (req, res, next) ->
	ret = new tropo.TropoWebAPI
	ret.say "Hello, 4 1 0. https://github.com/tropo/pre-recorded_audio_library/raw/master/DTMF%20Tones/Dtmf-9.wav"
	res.send tropo.TropoJSON ret

expressServer.get "/key9.wav", (req, res, next) ->
	res.sendfile "key9.wav"

expressServer.post "/text-inbound", (req, res, next) ->
	console.log req.param("session")
	instance = new tropo.TropoWebAPI
	if req.body.session.from.id in allowed.numbers
		instance.say "Access the gate within a minute."
	else
		instance.say "Not allowed"
	res.send TropoJSON tropo

server = http.createServer expressServer
server.listen (port = process.env.PORT ? 5080), -> console.log "Listening on port #{port}"