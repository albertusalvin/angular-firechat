angular.module "angularFirechat"
  .controller "ListRoomsCtrl", ($scope, FirechatFactory, LocalStorageService, AlertService, CommonService) ->

    $scope.user =
      id: null
      name: null

    $scope.rooms = []

    $scope.newRoom =
      name: null
      type: 'public'
      typeOptions: ['public', 'private']

    $scope.createRoom = ->
      FirechatFactory.createRoom $scope.newRoom.name, $scope.newRoom.type
        .then (roomId) ->
          AlertService.showSuccessMessage 'Room created!', 'SUCCESS'
        .catch (error) ->
          AlertService.showErrorMessage error, 'ERROR'

    $scope.enterRoom = (roomId) ->
      console.log 'Entering room ' + roomId

    init = ->
      try
        checkFirechatFactory()
        initUser()
        updateRooms()
      catch err
        AlertService.showErrorMessage err, 'ERROR'
        CommonService.redirectToMainPage()

    checkFirechatFactory = ->
      throw 'Firechat is not initialized, now redirecting...' unless FirechatFactory.isInitialized

    initUser = ->
      user = LocalStorageService.get 'userdata'
      if not user
        throw 'Unable to find user data'
      else if (not user.id) or (not user.name)
        throw 'User data invalid'
      else
        $scope.user.id = user.id
        $scope.user.name = user.name

    updateRooms = ->
      FirechatFactory.getRoomListByUser $scope.user.id
        .then (rooms) ->
          $scope.rooms = []
          for id, room of rooms
            $scope.rooms.push room
        .catch (error) ->
          throw error

    init()
    FirechatFactory.bindToFirechat 'user-update', updateRooms

