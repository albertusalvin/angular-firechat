setting =
  firebaseAppUrl: "https://sweltering-inferno-4271.firebaseio.com"
  tableNameFirechatUsers: "firechatUsers"

angular.module 'angularFirechat', [
    'ngAnimate',
    'ngCookies',
    'ngTouch',
    'ngSanitize',
    'ngRoute',
    'ui.bootstrap',
    'toastr',
    'firebaseFactory',
    'firechatFactory',
    'localstorageService',
    'alertService'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "app/main/main.html"
        controller: "MainCtrl"
      .otherwise
        redirectTo: "/"
  .constant 'GlobalSetting', setting

