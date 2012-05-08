(function() {
  var socket;

  socket = io.connect('/');

  $(function() {
    var all_fart_sounds, dom_audio, dom_farters, file_path, file_type, mascot;
    file_type = 'wav';
    file_path = '/sounds/';
    dom_audio = $('audio');
    dom_farters = $('.latest_farters').find('ul');
    mascot = $('.poop');
    all_fart_sounds = [];
    if (window.navigator.userAgent.match(/iPad/i) || window.navigator.userAgent.match(/iPhone/i)) {
      file_type = 'mp3';
      $('#ios').modal('show');
      $('#ios-ok').click(function() {
        dom_audio[0].play();
        return $('#ios').modal('hide');
      });
    }
    $('ul.all_fart_sounds').find('li').each(function() {
      return all_fart_sounds.push($(this).text());
    });
    if ($('.is_personal').length) {
      socket.on('my_fart', function(data) {
        return build_fart(data);
      });
    } else {
      socket.on('new_fart', function(data) {
        return build_fart(data);
      });
    }
    $('#sign_in').find('a').click(function() {
      var twat_val;
      twat_val = $('#sign_in').find('input').val();
      return window.location.href = window.location.origin + '/' + twat_val;
    });
    $('#wtf').find('a.sign_in').click(function() {
      return $('#wtf').modal('hide');
    });
    return window.build_fart = function(data) {
      var callback, fart_sound, rand, sound, template, _i, _len;
      template = "<li><a target='_blank' href='http://twitter.com/" + data.user + "'><img src='" + data.img + "' alt='@" + data.user + "' /></a><a target='_blank' href='http://twitter.com/" + data.user + "'>@" + data.user + "</a> : " + data.content + "</li>";
      dom_farters.prepend(template);
      fart_sound = '';
      for (_i = 0, _len = all_fart_sounds.length; _i < _len; _i++) {
        sound = all_fart_sounds[_i];
        if (data.tags[0].toLowerCase() === sound.toLowerCase()) {
          fart_sound = file_path + sound + '.' + file_type;
        }
      }
      if (fart_sound === '') {
        rand = Math.floor(Math.random() * all_fart_sounds.length);
        fart_sound = file_path + all_fart_sounds[rand] + '.' + file_type;
      }
      mascot.addClass('pooped');
      callback = function() {
        return mascot.removeClass('pooped');
      };
      setTimeout(callback, 1000);
      dom_audio.empty();
      dom_audio.append('<source src="' + fart_sound + '" type="audio/' + file_type + '" />');
      return dom_audio[0].play();
    };
  });

}).call(this);
