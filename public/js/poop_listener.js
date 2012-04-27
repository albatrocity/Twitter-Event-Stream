(function() {
  var socket;

  socket = io.connect('/');

  $(function() {
    var all_fart_sounds, default_sound, dom_audio, dom_farters, file_path, file_type;
    default_sound = 'massive_butt_fart';
    file_type = 'ogg';
    file_path = '/sounds/';
    dom_audio = $('audio');
    dom_farters = $('.latest_farters').find('ul');
    all_fart_sounds = [];
    $('ul.all_fart_sounds').find('li').each(function() {
      return all_fart_sounds.push($(this).text());
    });
    return socket.on('new_fart', function(data) {
      var fart_sound, template;
      console.log(data);
      template = "<li><a target='_blank' href='http://twitter.com/" + data.user + "'><img src='" + data.img + "' alt='@" + data.user + "' />@" + data.user + "</a> : " + data.content + "</li>";
      dom_farters.append(template);
      fart_sound = '';
      if ($.inArray(data.sound, all_fart_sounds)) {
        fart_sound = file_path + data.sound + '.' + file_type;
      } else {
        fart_sound = file_path + default_sound + '.' + file_type;
      }
      dom_audio.append('<source src="' + fart_sound + '" type="audio/' + file_type + '" />');
      return dom_audio[0].play();
    });
  });

}).call(this);
