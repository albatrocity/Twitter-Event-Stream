socket = io.connect('/')

$ ->

	file_type 		= 'wav'
	file_path 		= '/sounds/'

	dom_audio 		= $('audio')
	dom_farters 	= $('.latest_farters').find 'ul'
	mascot			= $('.poop')

	all_fart_sounds = []

	if (window.navigator.userAgent.match(/iPad/i) || window.navigator.userAgent.match(/iPhone/i))
		file_type = 'mp3'
		$('#ios').modal('show')
		$('#ios-ok').click ->
			dom_audio[0].play()
			$('#ios').modal('hide')

	$('ul.all_fart_sounds').find('li').each ->
		all_fart_sounds.push $(@).text()
	
	if $('.is_personal').length
		socket.on 'my_fart', (data) ->
			build_fart data
	else
		socket.on 'new_fart', (data) ->
			build_fart data

	$('#sign_in').find('a').click ->
		twat_val = $('#sign_in').find('input').val()
		window.location.href = window.location.origin + '/' + twat_val

	$('#wtf').find('a.sign_in').click ->
		$('#wtf').modal('hide')


	window.build_fart = (data) ->

		template = "<li><a target='_blank' href='http://twitter.com/#{data.user}'><img src='#{data.img}' alt='@#{data.user}' /></a><a target='_blank' href='http://twitter.com/#{data.user}'>@#{data.user}</a> : #{data.content}</li>"
		dom_farters.prepend template

		fart_sound = ''

		for sound in all_fart_sounds
			if data.tags[0].toLowerCase() == sound.toLowerCase()
				fart_sound 	= file_path + sound + '.' + file_type	
		if fart_sound == ''
			rand 		= Math.floor ( Math.random() * all_fart_sounds.length );
			fart_sound 	= file_path + all_fart_sounds[rand] + '.' + file_type

		mascot.addClass('pooped')
		callback = -> mascot.removeClass('pooped')
		setTimeout callback, 1000

		dom_audio.empty()
		dom_audio.append('<source src="' + fart_sound + '" type="audio/' + file_type + '" />')
		dom_audio[0].play()
