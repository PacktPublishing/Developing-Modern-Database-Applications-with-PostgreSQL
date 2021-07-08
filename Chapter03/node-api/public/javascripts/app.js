angular.module('nodeATM', [])

.controller('mainController', function($scope, $http) {

    $scope.formData = {};
    $scope.atmData = {};
	$scope.formData.County = "New York";
	$scope.formData.City = "New York";
	$scope.formData.State = "NY";
	

    // Get all atms
    $http.get('/api/atm-locations')
        .success(function(data) {
            $scope.atmData = data["data"];
            console.log(data["data"]);
        })
        .error(function(error) {
            console.log('Error: ' + error);
        });

    // Create a new atm
    $scope.createATM = function() {
        $http.post('/api/atm-locations', $scope.formData)
            .success(function(res) {
                $scope.formData = {};

                $http.get('/api/atm-locations')
                    .success(function(data) {
                    $scope.atmData = data["data"];
                    console.log(data["data"]);
                })
                .error(function(error) {
                    console.log('Error: ' + error);
                });

                console.log(res);
            })
            .error(function(error) {
                console.log('Error: ' + error);
            });
    };

    // Delete a atm
    $scope.deleteATM = function(atmID) {
        $http.delete('/api/atm-locations/' + atmID)
            .success(function(res) {             
                $http.get('/api/atm-locations')
                    .success(function(data) {
                    $scope.atmData = data["data"];
                    console.log(data["data"]);
                })
                .error(function(error) {
                    console.log('Error: ' + error);
                });

                console.log(res);
            })
            .error(function(data) {
                console.log('Error: ' + data);
            });
    };


});




