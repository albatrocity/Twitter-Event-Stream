socket = io.connect('/')

$ ->

	participants = $('.participants').find 'ul'

	
	if $('.is_personal').length
		socket.on 'my_tweet', (data) ->
			build_tweet data
	else
		socket.on 'new_tweet', (data) ->
			build_tweet data


	window.build_tweet = (data) ->

		template = "<li><a target='_blank' href='http://twitter.com/#{data.user}'><img src='#{data.img}' alt='@#{data.user}' /></a><a target='_blank' href='http://twitter.com/#{data.user}'>@#{data.user}</a> : #{data.content}</li>"
		participants.prepend template
