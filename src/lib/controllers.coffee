exports.init = (app) ->
  app.controller 'ColorBoxCtrl', ['$scope', ColorBoxCtrl]
  app.controller 'AboutCtrl', ['$scope', AboutCtrl]

ColorBoxCtrl = ($scope) ->
  $scope.hi = "hello"

AboutCtrl = ($scope) ->
