CS = require './colorsource'

exports.init = (app) ->
  app.controller 'ColorBoxCtrl', ['$scope', '$sce', '$http', '$routeParams', '$location', ColorBoxCtrl]
  app.controller 'AboutCtrl', ['$scope', AboutCtrl]

http_err_to_string = (err) ->
  if err instanceof Error
    err.message
  else if angular.isObject err
    "cannot #{err.config.method} #{err.config.url}: #{err.status} #{err.statusText}"
  else
    err

ColorBoxCtrl = ($scope, $sce, $http, $routeParams, $location) ->
  $scope.reset = ->
    $scope.colors = []          # template renders this
    $scope.status_bar = ''

  $scope.colordata_get = ->
    $scope.reset()

    $http.get($scope.colordata_active.url, { cache: true })
    .then (res) ->
      cs = new CS res.data, $scope.colordata_active
      if cs.colors.length > 0
        $scope.colors = cs.colors
      else
        throw new Error "#{$scope.colordata_active.url} is empty"

    .catch (err) ->
      $scope.status_bar = $sce.trustAsHtml "<b>Error:</b> #{http_err_to_string err}"

  $scope.colordata_find_by_name = (name) ->
    for params,idx in $scope.colordata
      return idx if name == params.name

    0

  # Main

  $scope.colordata = [
    {
      url: 'rgb.txt'
      name: 'X11'
      spaces: false
    }
    {
      url: 'css-basic.txt'
      name: 'CSS Basic'
      spaces: false
    }
    {
      url: 'css4.txt'
      name: 'CSS 4'
      spaces: false
    }
    {
      url: 'cga.txt'
      name: 'CGA 4-bit'
      spaces: true
    }
  ]

  $scope.colordata_active = $scope.colordata[$scope.colordata_find_by_name $routeParams.name]
  $scope.colordata_get()

  $scope.$watch 'colordata_active.url', (val) ->
#    console.log val, $routeParams.name
    $location.url "/#{$scope.colordata_active.name}"

AboutCtrl = ($scope) ->
