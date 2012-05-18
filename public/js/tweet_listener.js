(function() {
  var socket;

  socket = io.connect('/');

  $(function() {
    var mascot, participants;
    participants = $('.participants').find('ul');
    mascot = $('.poop');
    if ($('.is_personal').length) {
      socket.on('my_tweet', function(data) {
        return build_tweet(data);
      });
    } else {
      socket.on('new_tweet', function(data) {
        return build_tweet(data);
      });
    }
    return window.build_tweet = function(data) {
      var fart_sound, template;
      template = "<li><a target='_blank' href='http://twitter.com/" + data.user + "'><img src='" + data.img + "' alt='@" + data.user + "' /></a><a target='_blank' href='http://twitter.com/" + data.user + "'>@" + data.user + "</a> : " + data.content + "</li>";
      participants.prepend(template);
      return fart_sound = '';
    };
  });

}).call(this);
