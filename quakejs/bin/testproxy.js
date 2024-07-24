var path = require('path');
var fs = require('fs'); 
var gms = 'http://54.167.195.212:27960';

var express = require('express');
var app = express();

// SSL

var privateKey = fs.readFileSync('/etc/ssl/private/ssl-cert-snakeoil.key'); 
var certificate = fs.readFileSync('/etc/ssl/certs/ssl-cert-snakeoil.pem'); 

var credentials = {key: privateKey, cert: certificate};
var https = require('https');
var httpsServer = https.createServer(credentials, app);

var httpProxy = require('http-proxy');
var proxy = httpProxy.createProxyServer({
 secure : false,
 target : gms
});
 

httpsServer.on('upgrade', function (req, socket, head) {
    proxy.ws(req, socket, head);
 });
  
 proxy.on('error', function (err, req, res) {
    console.log(err);
    try {
     res.writeHead(500, {
      'Content-Type': 'text/plain'
     });
     res.end('Error: ' + err.message);
    } catch(err) {
     console.log(err);
    }
   });
    
   httpsServer.on('error', function (err, req, res) {
    console.log('error message');
    console.log(err);
    try {
     res.writeHead(500, {
      'Content-Type': 'text/plain'
     });
     res.end('Error: ' + err.message);
    } catch(err) {
     console.log(err);
    }
   });

   httpsServer.on('proxyRes', function (proxyRes, req, res) {
    console.log('proxyRes message');

console.log('RAW Response from the target', JSON.stringify(proxyRes.headers, true, 2));
});

httpsServer.on('open', function (proxySocket) {
    console.log('open message');

    // listen for messages coming FROM the target here
    proxySocket.on('data', hybiParseAndLogMessage);
  });

  httpsServer.on('close', function (res, socket, head) {
    console.log('close message');

    // view disconnected websocket connections
    console.log('Client disconnected');
  });

   app.use(express.static(path.join(__dirname, 'public')));
 
   app.all("/genesys/*", function(req, res) {
    proxy.web(req, res);
   });
    
   httpsServer.listen(27961);