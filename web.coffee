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
		instance.say "https://github.com/tropo/pre-recorded_audio_library/raw/master/DTMF%20Tones/Dtmf-9.wav"
	else
		say = new Say "Please enter the passcode."
		choices = new Choices "[#{allowed.passcode.length} DIGITS]", "dtmf"
		instance.ask choices, 3, true, null, "passcode", null, true, say, 5, null
		instance.on "continue", null, "/voice-passcode", true
	res.send tropo.TropoJSON instance

expressServer.post "/voice-passcode", (req, res, next) ->
	instance = new tropo.TropoWebAPI
	if req.body.result?.actions?.passcode?.value is allowed.passcode
		instance.say "https://github.com/tropo/pre-recorded_audio_library/raw/master/DTMF%20Tones/Dtmf-9.wav"
	else
		instance.say "Sorry, wrong passcode."
	res.send tropo.TropoJSON instance

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