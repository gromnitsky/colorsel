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
    $scope.colors_filter = $routeParams.filter || ''
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

  $scope.colordata_active_change = ->
    $location.url "/c/#{$scope.colordata_active.name}?filter=#{$scope.colors_filter}"

  $scope.colors_filter_change = ->
    return if $scope.colors_filter == ""
    # TODO: chage the location w/o triggering the router
    # $location.search "filter", $scope.colors_filter

  $scope.colors_filter_clean = ->
    $scope.colors_filter = ""


  # Main

  $scope.template_body = 'template.colorbox'
  $scope.nav_current = 'Home'

  $scope.colordata = [
    {
      url: 'test.txt'
      name: 'test'
      spaces: false
      idx_plus: 1
      hidden: true
    }
    {
      url: 'rgb.txt'
      name: 'X11'
      spaces: false
      idx_plus: 1
    }
    {
      url: 'css-basic.txt'
      name: 'CSS Basic'
      spaces: false
      idx_plus: 1
    }
    {
      url: 'css4.txt'
      name: 'CSS 4'
      spaces: false
      idx_plus: 1
    }
    {
      url: 'cga.txt'
      name: 'CGA 4-bit'
      spaces: true
      idx_plus: 0
    }
  ]

  $scope.colordata_active = $scope.colordata[$scope.colordata_find_by_name $routeParams.name]
  $scope.colordata_get()



AboutCtrl = ($scope) ->
  $scope.template_body = 'template.about'
  $scope.nav_current = 'Help'
