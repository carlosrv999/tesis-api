'use strict';
var execProcess = require("../exec.js");

module.exports = function (server) {
  // Install a `/` route that returns server status
  var router = server.loopback.Router();
  router.get('/', server.loopback.status());
  router.get('/test', (req, res) => {
    execProcess.result("sh server/scripts/script.sh carlosrv22 >> app.log", function (err, response) {
      if (!err) {
        res.status(200).send({ "ok": "okidoki" });
      } else {
        res.status(500).send({"error": JSON.stringify(err)});
      }
    });
    
  });
  server.use(router);
};
