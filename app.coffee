express		 = require 'express'
path   		 = require 'path'
fs     		 = require 'fs'
util   		 = require 'util'
stylus 		 = require 'stylus'
twitter		 = require 'ntwitter'
twitext		 = require 'twitter-text'
app    		 = express.createServer()
io     		 = require('socket.io').listen(app)
port   		 = process.env.PORT || 3001

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
	

tweet = new twitter
	consumer_key 		: process.env.TWITTERCONSUMERKEY
	consumer_secret		: process.env.TWITTERCONSUMERSECRET
	access_token_key	: process.env.TWITTERACCESSTOKEN
	access_token_secret	: process.env.TWITTERACCESSTOKENSECRET


build_tweet_stream = (req, res, next) ->
	
	follow_term 	= 'crabs'
	user_id 		= [0]

	if req
		if req.user_id
			follow_term = 'fartcharade'
			user_id 	= [req.user_id]
			next()

	io.sockets.on 'connection', (socket) ->
		tweet.stream 'statuses/filter',
			track 	: follow_term
			follow  : user_id
		, (stream) ->
			stream.on 'data', (data) ->

				client_data = {
					content : twitter.autoLink(data.text)
					img 	: data.user.profile_image_url
					user 	: data.user.screen_name
					tags 	: []
				}

				client_data.content.replace /[#]+[A-Za-z0-9-_]+/g, (tag) ->
					client_data.tags.push tag.replace('#', '')

				if req
					socket.emit 'my_tweet',
						client_data
				else
					socket.emit 'new_tweet',
						client_data


app.get '/', (req, res, next) ->
	res.render 'index'


build_tweet_stream()
app.listen port
console.log 'server running on port ' + port 