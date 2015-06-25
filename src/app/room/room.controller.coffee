angular.module "angularFirechat"
  .controller "RoomCtrl", ($scope, $location, FirechatFactory, AlertService, CommonService, UtilityService) ->

    $scope.currentRoom =
      id: null
      name: null
      messages: []

    $scope.newMessage =
      text: null

    $scope.users = []

    $scope.sendMessage = ->
      FirechatFactory.sendMessage $scope.currentRoom.id, $scope.newMessage.text
        .then ->
          updateMessages()
          $scope.newMessage.text = null
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code

    $scope.exitRoom = ->
      $location.url '/listRooms'

    init = ->
      try
        initRoom()
        updateMessages()
        getAllUsers()
      catch err
        AlertService.showErrorMessage err, 'ERROR'
        CommonService.redirectToMainPage()

    initRoom = ->
      room = FirechatFactory.getCurrentRoom()
      if room.id and room.name
        $scope.currentRoom.id = room.id
        $scope.currentRoom.name = room.name
      else throw 'Invalid room'

    updateMessages = ->
      FirechatFactory.getMessages $scope.currentRoom.id
        .then (messages) ->
          assignMessages messages
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code          

    assignMessages = (messages) ->
      arr = UtilityService.convertObjectToArray messages, 'id'
      sorted = UtilityService.sortByAttribute arr, 'timestamp'
      $scope.currentRoom.messages = []

      for msg in sorted
        $scope.currentRoom.messages.push msg

    getAllUsers = ->
      FirechatFactory.getAllUsers()
        .then (data) ->
          $scope.users = UtilityService.convertObjectToArray data

    init()
    FirechatFactory.bindToFirechat 'message-add', updateMessages
    FirechatFactory.bindToFirechat 'message-remove', updateMessages
