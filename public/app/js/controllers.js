'use strict';

angular.module('air-menu.controllers', [])
	.controller('MainCtrl', [ '$scope', 'session', function($scope, session) {
		$scope.$on('air-menu-ui.event.userLoggedIn', function() {
			$scope.session = session;
		});
	}])

	.controller('HomeCtrl', [ '$scope', 'Me', function($scope, Me) {
		$scope.fetch = function() {
			Me.get(function(data) {
				$scope.user = data['me'];
			});
		};

		$scope.$on('air-menu-ui.event.userLoggedIn', function() {
			$scope.fetch();
		});
	}])

	.controller('LoginCtrl', [ '$scope', '$location', 'session', function($scope, $location, session) {
		$scope.handler = function(username, password, callback) {
			session.create(username, password, function(successful) {
				if (callback) callback(successful);
				if (successful) $location.path('/');
			});
		}
	}])

	.controller('DocumentationCtrl', [ '$scope', 'Docs', function($scope, Docs) {
		$scope.fetch = function() {
			Docs.get(function(data) {
				$scope.docs = data['docs'];
			})
		};

		$scope.fetch();
	}]);