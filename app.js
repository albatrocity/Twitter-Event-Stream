(function() {
  var app, build_tweet_stream, express, fs, io, path, port, stylus, tweet, twitext, twitter, util;

  express = require('express');

  path = require('path');

  fs = require('fs');

  util = require('util');

  stylus = require('stylus');

  twitter = require('ntwitter');

  twitext = require('twitter-text');

  app = express.createServer();

  io = require('socket.io').listen(app);

  port = process.env.PORT || 3001;

  io.configure(function() {
    io.set('transports', ['xhr-polling']);
    io.set('polling duration', 10);
    return io.set('log level', 1);
  });

  app.use(require('connect-assets')({
    src: 'public'
  }));

  app.configure(function() {
    app.use(express.static(path.join(__dirname, 'public')));
    app.use(stylus.middleware({
      debug: true,
      force: true,
      src: "" + __dirname + "/public",
      dest: "" + __dirname + "/public"
    }));
    app.set('views', path.join(__dirname, 'public/views'));
    return app.set('view engine', 'jade');
  });

  tweet = new twitter({
    consumer_key: process.env.TWITTERCONSUMERKEY,
    consumer_secret: process.env.TWITTERCONSUMERSECRET,
    access_token_key: process.env.TWITTERACCESSTOKEN,
    access_token_secret: process.env.TWITTERACCESSTOKENSECRET
  });

  build_tweet_stream = function(req, res, next) {
    var follow_term, user_id;
    follow_term = 'crabs';
    user_id = [0];
    if (req) {
      if (req.user_id) {
        follow_term = 'crabs';
        user_id = [req.user_id];
        next();
      }
    }
    return io.sockets.on('connection', function(socket) {
      return tweet.stream('statuses/filter', {
        track: follow_term,
        follow: user_id
      }, function(stream) {
        return stream.on('data', function(data) {
          var client_data;
          client_data = {
            content: twitter.autoLink(data.text),
            img: data.user.profile_image_url,
            user: data.user.screen_name,
            tags: []
          };
          client_data.content.replace(/[#]+[A-Za-z0-9-_]+/g, function(tag) {
            return client_data.tags.push(tag.replace('#', ''));
          });
          if (req) {
            return socket.emit('my_tweet', client_data);
          } else {
            return socket.emit('new_tweet', client_data);
          }
        });
      });
    });
  };

  app.get('/', function(req, res, next) {
    return res.render('index');
  });

  build_tweet_stream();

  app.listen(port);

  console.log('server running on port ' + port);

}).call(this);
