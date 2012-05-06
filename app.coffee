express    	= require 'express'
path       	= require 'path'
fs         	= require 'fs'
util 		= require 'util'
stylus     	= require 'stylus'
twitter 	= require 'ntwitter'
app        	= express.createServer()
io			= require('socket.io').listen(app)
port       	= process.env.PORT || 3001

io.configure ->
	io.set('transports', ['xhr-polling']); 
	io.set('polling duration', 10); 
	io.set('log level', 1)

app.use require('connect-assets')(src : 'public')

app.configure ->
	#app.use express.logger format: ':method :url :status'
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

get_user_id = (req, res, next) ->
	twat.showUser req.params.user, (err, data) ->
		if err
			res.render 'notfound', files : req.sound_files
		else
			req.user_id = data[0].id
			next()


build_tweet_stream = (req, res, next) ->
	
	follow_term 	= 'fart'
	user_id 		= [0]

	if req
		if req.user_id
			follow_term = 'fartcharade'
			user_id 	= [req.user_id]
			next()

	io.sockets.on 'connection', (socket) ->
		twat.stream 'statuses/filter',
			track 	: follow_term
			follow  : user_id
		, (stream) ->
			stream.on 'data', (data) ->

				client_data = {
					content : data.text
					img 	: data.user.profile_image_url
					user 	: data.user.screen_name
					tags 	: []
				}

				client_data.content.replace /[#]+[A-Za-z0-9-_]+/g, (tag) ->
					client_data.tags.push tag.replace('#', '')

				console.log client_data.content

				if req
					socket.emit 'my_fart',
						client_data
				else
					socket.emit 'new_fart',
						client_data

get_all_files = (req, res, next) ->
	fs.readdir "#{__dirname}/public/sounds", (err, all_files) ->
		sound_files = []	
		for file in all_files
			sound_files.push(file.substring(0, file.lastIndexOf('.')))
		req.sound_files = sound_files
		next()

app.get '/', get_all_files, (req, res, next) ->
	res.render 'index', files : req.sound_files

app.get '/:user', get_all_files, get_user_id, build_tweet_stream, (req, res) ->
	res.render 'user', files : req.sound_files

build_tweet_stream()
app.listen port
console.log 'server running on port ' + port 