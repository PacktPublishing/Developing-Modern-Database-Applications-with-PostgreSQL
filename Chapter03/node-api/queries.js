var promise = require('bluebird');

var options = {
  // Initialization Options
  promiseLib: promise
};

var pgp = require('pg-promise')(options);
var connectionString = 'postgres://dba:bookdemo@atm.c3qdepivtce8.us-east-1.rds.amazonaws.com:5432/atm';
var db = pgp(connectionString);

// add query functions

module.exports = {
  getAllATMLocations: getAllATMLocations,
  getSingleATMLocation: getSingleATMLocation,
  createATMLocation: createATMLocation,
  updateATMLocation: updateATMLocation,
  removeATMLocation: removeATMLocation
};

function getAllATMLocations(req, res, next) {
  db.any('select * from public."ATM locations"')
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved ALL ATM locations',
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function getSingleATMLocation(req, res, next) {
  var atmID = parseInt(req.params.id);
  console.log(atmID);

  db.one('select * from public."ATM locations" where "ID" = $1', atmID)
    .then(function (data) {
      res.status(200)
        .json({
          status: 'success',
          data: data,
          message: 'Retrieved ONE ATM location'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function createATMLocation(req, res, next) {
  db.none('insert into public."ATM locations"("BankName", "Address", "County", "City", "State", "ZipCode")' +
      'values(${BankName}, ${Address}, ${County}, ${City}, ${State}, ${ZipCode})',
    req.body)
    .then(function () {
      res.status(200)
        .json({
          status: 'success',
          message: 'Inserted ONE ATM Location'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}


function updateATMLocation(req, res, next) {
  var atmID = parseInt(req.params.id);
  console.log(atmID);

  var field = req.body.field;
  var newvalue = req.body.newvalue;
  console.log(field);
  console.log(newvalue);

  db.none('update public."ATM locations" set "'+field+'" = \''+newvalue+'\' where "ID" = '+ atmID)
    .then(function () {
      res.status(200)
        .json({
          status: 'success',
          message: 'Updated ATM Location'
        });
    })
    .catch(function (err) {
      return next(err);
    });
}

function removeATMLocation(req, res, next) {
  var atmID = parseInt(req.params.id);
  db.result('delete from public."ATM locations" where "ID" = $1', atmID)
    .then(function (result) {
      /* jshint ignore:start */
      res.status(200)
        .json({
          status: 'success',
          message: 'Removed an ATM Location'
        });
      /* jshint ignore:end */
    })
    .catch(function (err) {
      return next(err);
    });
}
