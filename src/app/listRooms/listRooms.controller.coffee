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

    $scope.newMessage =
      text: null

    $scope.pageLoading = true

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
          getMessages roomId
        .catch (error) ->
          AlertService.showErrorMessage "Can't enter room", 'ERROR'

    $scope.sendMessage = ->
      FirechatFactory.sendMessage $scope.currentRoom.id, $scope.newMessage.text
        .then (data) ->
          console.log 'Done sending message'
          console.log data

          getMessages $scope.currentRoom.id
          $scope.newMessage.text = null
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code

    init = ->
      try
        initUser()
        updateListRooms()
        $scope.pageLoading = false
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

    updateListRooms = ->
      FirechatFactory.getRoomListByUser $scope.user.id
        .then (rooms) ->
          $scope.rooms = []
          for id, room of rooms
            $scope.rooms.push room
        .catch (error) ->
          throw error

    getMessages = (roomId) ->
      FirechatFactory.getMessages roomId
        .then (messages) ->

          $scope.currentRoom.messages = []
          for id, msg of messages
            msg.id = id
            $scope.currentRoom.messages.push msg

        .catch (error) ->
          AlertService.showErrorMessage error.message, error.done

    init()  
    FirechatFactory.bindToFirechat 'user-update', updateListRooms


