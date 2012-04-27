socket = io.connect('/')

$ ->

	ul = $('.latest_farters').find 'ul'
	socket.on 'new_fart', (data) ->
		console.log data
		#template = "<li style='display:none;'><a target='_blank' href='http://twitter.com/#{data.username}'>@#{data.username}</a> : #{data.message}</li>"
		#ul.append template
		#$(template).fadeIn()