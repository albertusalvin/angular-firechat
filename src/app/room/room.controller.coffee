angular.module "angularFirechat"
  .controller "RoomCtrl", ($scope, FirechatFactory, AlertService) ->

    $scope.currentRoom =
      id: null
      name: null
      messages: []

    $scope.newMessage =
      text: null

    $scope.sendMessage = ->
      FirechatFactory.sendMessage $scope.currentRoom.id, $scope.newMessage.text
        .then (data) ->
          getMessages $scope.currentRoom.id
          $scope.newMessage.text = null
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code

    init = ->
      initRoom()
      getMessages $scope.currentRoom.id

    initRoom = ->
      room = FirechatFactory.getCurrentRoom()
      $scope.currentRoom.id = room.id
      $scope.currentRoom.name = room.name

    getMessages = (roomId) ->
      FirechatFactory.getMessages roomId
        .then (messages) ->
          updateMessages messages
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.done

    updateMessages = (messages) ->
      $scope.currentRoom.messages = []
      for id, msg of messages
        msg.id = id
        $scope.currentRoom.messages.push msg

    init()
