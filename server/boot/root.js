'use strict';
var execProcess = require("../exec.js");

module.exports = function (server) {
  // Install a `/` route that returns server status
  var router = server.loopback.Router();
  router.get('/', server.loopback.status());
  router.get('/test', (req, res) => {
    execProcess.result("sh server/scripts/script.sh carlosrv21", function (err, response) {
      if (!err) {
        console.log(response);
      } else {
        console.log(err);
      }
    });
    res.status(200).send({ "ok": "okidoki" });
  });
  server.use(router);
};
