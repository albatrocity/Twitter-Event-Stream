socket = io.connect('/')

$ ->
	
	default_sound 	= 'massive_butt_fart'
	file_type 		= 'ogg'
	file_path 		= '/sounds/'

	dom_audio 		= $('audio')
	dom_farters 	= $('.latest_farters').find 'ul'

	all_fart_sounds = []

	$('ul.all_fart_sounds').find('li').each ->
		all_fart_sounds.push $(@).text()

	socket.on 'new_fart', (data) ->
		console.log data
		template = "<li><a target='_blank' href='http://twitter.com/#{data.user}'><img src='#{data.img}' alt='@#{data.user}' />@#{data.user}</a> : #{data.content}</li>"
		dom_farters.append template

		fart_sound = ''
		if $.inArray(data.sound, all_fart_sounds)
			fart_sound = file_path + data.sound + '.' + file_type
		else
			fart_sound = file_path + default_sound + '.' + file_type

		dom_audio.append('<source src="' + fart_sound + '" type="audio/' + file_type + '" />')
		dom_audio[0].play()