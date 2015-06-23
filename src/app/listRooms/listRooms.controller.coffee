angular.module "angularFirechat"
  .controller "ListRoomsCtrl", ($scope, LocalStorageService, AlertService) ->

    $scope.user =
      name: null

    $scope.rooms = []

    $scope.enterRoom = (roomId) ->
      console.log 'Entering room ' + roomId

    init = ->
      user = LocalStorageService.get 'userdata'
      if not user
        errorNoUserData()
      else
        initUser user
        initRooms user.rooms if user.rooms

    initUser = (user) ->
      if not user.name
        errorInvalidUserData()
      else
        $scope.user.name = user.name

    initRooms = (rooms) ->
      for id, room of rooms
        $scope.rooms.push room

    errorNoUserData = ->
      AlertService.showErrorMessage 'Unable to find user data', 'LOGIN ERROR'

    errorInvalidUserData = ->
      AlertService.showErrorMessage 'User data invalid', 'LOGIN ERROR'

    init()