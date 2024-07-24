// Copyright 2020 QuakeJS authors.
console.log('running proxy script') 

var _ = require('underscore');
var httpProxy = require('http-proxy');
var fs = require('fs');
var https = require('https');
var logger = require('winston');
var opt = require('optimist');

var argv = require('optimist')
    .describe('config', 'Location of the configuration file').default('config', './config.json')
    .argv;

// if (argv.h || argv.help) {
//     opt.showHelp();
//     return;
// }

logger.cli();
logger.level = 'debug';

var config = loadConfig(argv.config);

function loadConfig(configPath) {
    var config = {
        listenPort: 27961,
        proxyAddr: '10.0.2.216',
        proxyPort: 27960,
        key: "default privatekey",
        cert: "default certificate"
    };

    try {
        console.log('loading config file from ' + configPath + '..')
        logger.info('loading config file from ' + configPath + '..');
        var data = require(configPath);
        // _.extend(config, data);
        config.key = data.key;
        config.cert = data.cert;
        console.log('key '+  config.key);
        console.log('cert '+  config.cert);
    } catch (e) {
        logger.warn('failed to load config', e);
    }

    return config;
}

// Using self-signed certificate
var proxy = new httpProxy.createProxyServer({
    secure : false,
    target: {
        host: config.proxyAddr,
        port: config.proxyPort
    }
});



const opts = {
    key: fs.readFileSync(config.key),
    cert: fs.readFileSync(config.cert)
};
var proxyServer = https.createServer(opts, function (req, res) {
    proxy.web(req, res);
});

proxyServer.on('upgrade', function (req, socket, head) {
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
    

proxyServer.on('error', function (err, req, res) {
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

proxyServer.on('proxyRes', function (proxyRes, req, res) {
    console.log('proxyRes message');

console.log('RAW Response from the target', JSON.stringify(proxyRes.headers, true, 2));
});

proxyServer.on('open', function (proxySocket) {
    console.log('open message');

    // listen for messages coming FROM the target here
    proxySocket.on('data', hybiParseAndLogMessage);
  });

  proxyServer.on('close', function (res, socket, head) {
    console.log('close message');

    // view disconnected websocket connections
    console.log('Client disconnected');
  });

proxyServer.listen(config.listenPort, '0.0.0.0',  function() {
    
    logger.info('wssproxy server forwarding from wss://' + proxyServer.address().address + ":" + proxyServer.address().port + " to ws://" + config.proxyAddr + ":" + config.proxyPort);
    console.log('wssproxy server forwarding from wss://' + proxyServer.address().address + ":" + proxyServer.address().port + " to ws://" + config.proxyAddr + ":" + config.proxyPort);
});