controllers = require './controllers'
filters = require './filters'

appname = 'colorsel'

app = angular.module appname, ['ngRoute']
controllers.init app
filters.init app

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .when '/:name*', {
    templateUrl: 'template.colorbox'
    controller: "ColorBoxCtrl"
  }
  .when '/about', {
    templateUrl: 'template.about'
    controller: "AboutCtrl"
  }
  .otherwise {
    redirectTo: '/X11'
  }
]


module.exports = appname
