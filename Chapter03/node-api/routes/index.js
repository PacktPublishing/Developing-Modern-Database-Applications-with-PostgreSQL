var express = require('express');
var router = express.Router();
var path = require('path');

var db = require('../queries');


router.get('/api/atm-locations', db.getAllATMLocations);
router.get('/api/atm-locations/:id', db.getSingleATMLocation);
router.post('/api/atm-locations', db.createATMLocation);
router.put('/api/atm-locations/:id', db.updateATMLocation);
router.delete('/api/atm-locations/:id', db.removeATMLocation);

router.get('/', function(req, res, next) {
  res.sendFile('index.html');
});

module.exports = router;

