http = require "http"
express = require "express"
tropo = require "tropo-webapi"
allowed = require "./whitelist.json"

currentState = false
timerId = null

expressServer = express()
expressServer.configure ->

	expressServer.use express.compress()
	expressServer.use express.bodyParser()
	expressServer.use expressServer.router

expressServer.post "/voice-inbound", (req, res, next) ->
	instance = new tropo.TropoWebAPI
	if currentState
		instance.say "Hello, 4 1 0. https://github.com/tropo/pre-recorded_audio_library/raw/master/DTMF%20Tones/Dtmf-9.wav"
	else
		instance.say "Sorry, Bye Bye."
	res.send tropo.TropoJSON instance

expressServer.get "/key9.wav", (req, res, next) ->
	res.sendfile "key9.wav"

expressServer.post "/text-inbound", (req, res, next) ->
	instance = new tropo.TropoWebAPI
	if req.body.session.from.id in allowed.numbers
		if timerId?
			clearTimeout timerId
		currentState = true
		timerId = setTimeout (->
			currentState = false
			timerId = null
		), 60 * 1000
		console.log "Allowed access to #{req.body.session.from.id}"
		instance.say "Access the gate within a minute."
	else
		console.log "Denied access to #{req.body.session.from.id}"
		instance.say "Not allowed"
	res.send TropoJSON instance

server = http.createServer expressServer
server.listen (port = process.env.PORT ? 5080), -> console.log "Listening on port #{port}"