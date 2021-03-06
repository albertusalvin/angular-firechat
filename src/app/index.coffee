setting =
  firebaseAppUrl: "https://sweltering-inferno-4271.firebaseio.com"
  tableNameFirechatUsers: "firechatUsers"
  tableNameFirechat: "firechat"
  errMsgTimeout: 5000

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
    'alertService',
    'commonService',
    'utilityService'
  ]
  .config ($routeProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "app/main/main.html"
        controller: "MainCtrl"
      .when "/listRooms",
        templateUrl: "app/listRooms/listRooms.html"
        controller: "ListRoomsCtrl"
      .when "/room",
        templateUrl: "app/room/room.html"
        controller: "RoomCtrl"
      .otherwise
        redirectTo: "/"
  .constant 'GlobalSetting', setting

