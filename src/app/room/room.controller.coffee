angular.module "angularFirechat"
  .controller "RoomCtrl", ($scope, $location, FirechatFactory, AlertService, CommonService, UtilityService) ->

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

    $scope.exitRoom = ->
      $location.url '/listRooms'

    init = ->
      try
        initRoom()
        getMessages $scope.currentRoom.id
      catch err
        AlertService.showErrorMessage err, 'ERROR'
        CommonService.redirectToMainPage()

    initRoom = ->
      room = FirechatFactory.getCurrentRoom()
      if room.id and room.name
        $scope.currentRoom.id = room.id
        $scope.currentRoom.name = room.name
      else throw 'Invalid room'

    getMessages = (roomId) ->
      FirechatFactory.getMessages roomId
        .then (messages) ->
          updateMessages messages
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.done

    updateMessages = (messages) ->
      arr = UtilityService.convertObjectToArray messages, 'id'
      sorted = UtilityService.sortByAttribute arr, 'timestamp'
      $scope.currentRoom.messages = []

      for msg in sorted
        $scope.currentRoom.messages.push msg

    init()
