'use strict';
const execProcess = require("../exec.js");
const request = require('request');
const env = require('../../env.json');
const utils = require('./utils');

module.exports = function (server) {
  // Install a `/` route that returns server status
  var router = server.loopback.Router();
  router.get('/', server.loopback.status());
  router.post('/createApp', (req, res) => {
    console.log(req.body);
    let appname = req.body.appname;
    let jenkins_crumb = req.body.jenkins_crumb;
    execProcess.result(`sh server/scripts/script.sh ${appname} >> app.log`, function (err, response) {
      if (!err) {
        var options = {
          method: 'POST',
          url: `${env.jenkins_url}/createItem`,
          qs: { name: appname },
          headers:
          {
            'cache-control': 'no-cache',
            'Authorization': `Basic ${env.jenkins_basic_auth}`,
            'Jenkins-Crumb': jenkins_crumb,
            'Content-Type': 'text/xml'
          },
          body: utils.getBodyString(appname)
        };
        request(options, function (error, response) {
          if (error) return res.status(500).send(error);
          res.status(200).send(response);
        });
      } else {
        res.status(500).send({ "error": JSON.stringify(err) });
      }
    });

  });

  server.use(router);

};
