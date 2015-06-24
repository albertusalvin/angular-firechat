angular.module "angularFirechat"
  .controller "ListRoomsCtrl", ($scope, FirechatFactory, AlertService, CommonService) ->

    $scope.user =
      id: null
      name: null

    $scope.rooms = []

    $scope.newRoom =
      name: null
      type: 'public'
      typeOptions: ['public', 'private']

    $scope.currentRoom =
      id: null
      name: null
      messages: []

    $scope.formCreateRoomDisabled = true

    $scope.createRoom = ->
      FirechatFactory.createRoom $scope.newRoom.name, $scope.newRoom.type
        .then (roomId) ->
          AlertService.showSuccessMessage 'Room created!', 'SUCCESS'
        .catch (error) ->
          AlertService.showErrorMessage error, 'ERROR'

    $scope.enterRoom = (roomId, roomName) ->
      FirechatFactory.enterRoom roomId
        .then ->
          $scope.currentRoom.id = roomId
          $scope.currentRoom.name = roomName
        .catch (error) ->
          AlertService.showErrorMessage "Can't enter room", 'ERROR'

    init = ->
      try
        initUser()
        updateRooms()
        $scope.formCreateRoomDisabled = false
      catch err
        AlertService.showErrorMessage err, 'ERROR'
        CommonService.redirectToMainPage()

    initUser = ->
      user = FirechatFactory.getUser()
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


