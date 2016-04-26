
/**
 * Module dependencies.
 */

var express = require('express'),
	app = express(),
	http = require('http'),
    config = require('./local_config.js'),
    cors = require('cors'),
	req= require("request") ;
var server = http.createServer(app);
var conn = require("./server/controller/connection.js");
app.configure(function(){
	app.set('port', process.env.PORT || 3003);
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use( express.cookieParser() );
	app.use(express.session({
		secret : 'keyboard cat'
	}));
	app.use(cors())
});

app.get('/endpoints', function(req, res){
  if(config.webendpoints){
    res.jsonp(config.webendpoints);
  }else{
    res.jsonp({});
  }
});

console.log("isSTBAuthEnabled : "+ config.isSTBAuthEnabled);

app.get('/connection',function(req, res){
console.log("SANNNN====================================================")
	conn.normal_connect( function(d){
		console.log("SERVER HELLO",d)
        res.send(d);
	});
});
// The socket interfaces needs an instance of the express app and server due to the way express 3.0 works...
require('socket.io').listen(server);

server.listen(app.get('port'), function(){
  console.log("XView-STBClient Node Express server listening on port " + app.get('port'));
});




