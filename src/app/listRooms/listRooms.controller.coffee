angular.module "angularFirechat"
  .controller "ListRoomsCtrl", ($scope, FirechatFactory, LocalStorageService, AlertService) ->

    $scope.user =
      name: null

    $scope.rooms = []

    $scope.newRoom =
      name: null
      type: 'public'
      typeOptions: ['public', 'private']

    $scope.createRoom = ->
      FirechatFactory.createRoom $scope.newRoom.name, $scope.newRoom.type
        .then (roomId) ->
          console.log 'room generated'
          console.log roomId

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

    initRooms = ->
      FirechatFactory.getRoomListByUser $scope.user.id
        .then (rooms) ->
          for id, room of rooms
            $scope.rooms.push room
        .catch (error) ->
          throw error

    errorNoUserData = ->
      AlertService.showErrorMessage 'Unable to find user data', 'LOGIN ERROR'

    errorInvalidUserData = ->
      AlertService.showErrorMessage 'User data invalid', 'LOGIN ERROR'

    init()