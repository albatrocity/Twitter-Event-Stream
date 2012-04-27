express    	= require 'express'
path       	= require 'path'
fs         	= require 'fs'
util 		= require 'util'
stylus     	= require 'stylus'
twitter 	= require 'ntwitter'
app        	= express.createServer()
io			= require('socket.io').listen(app)
port       	= process.env.PORT || 3001

app.use require('connect-assets')(src : 'public')

app.configure ->
	app.use express.logger format: ':method :url :status'
	app.use express.static path.join __dirname, 'public'
	app.use stylus.middleware
		debug: true
		force: true
		src: "#{__dirname}/public"
		dest: "#{__dirname}/public"
	app.set 'views', path.join __dirname, 'public/views'
	app.set 'view engine', 'jade'

twat = new twitter
	consumer_key 		: process.env.TWITTERCONSUMERKEY
	consumer_secret		: process.env.TWITTERCONSUMERSECRET
	access_token_key	: process.env.TWITTERACCESSTOKEN
	access_token_secret	: process.env.TWITTERACCESSTOKENSECRET

io.sockets.on 'connection', (socket) ->
	twat.stream 'statuses/filter',
		track : 'fart'
	, (stream) ->
		stream.on 'data', (data) ->
			client_data = {
				content : data.text
				img 	: data.user.profile_image_url_https
				user 	: data.user.screen_name
			}
			socket.broadcast.emit 'new_fart',
				client_data

app.get '/', (req, res) ->
	fs.readdir "#{__dirname}/public/sounds", (err, all_files) ->
		res.render 'index', files : all_files

app.listen port
console.log 'server running on port ' + port 