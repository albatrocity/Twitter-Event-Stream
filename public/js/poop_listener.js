(function() {
  var socket;

  socket = io.connect('/');

  $(function() {
    var ul;
    ul = $('.latest_farters').find('ul');
    return socket.on('new_fart', function(data) {
      return console.log(data);
    });
  });

}).call(this);
