controllers = require './controllers'
filters = require './filters'
directives = require './directives'

appname = 'colorsel'

app = angular.module appname, ['ngRoute']
controllers.init app
filters.init app
directives.init app

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .when '/about', {
    templateUrl: 'template.main'
    controller: "AboutCtrl"
  }
  .when '/c/:name*', {
    templateUrl: 'template.main'
    controller: "ColorBoxCtrl"
  }
  .otherwise {
    redirectTo: '/c/X11'
  }
]


module.exports = appname
