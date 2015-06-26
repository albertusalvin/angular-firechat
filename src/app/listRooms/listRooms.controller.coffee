angular.module "angularFirechat"
  .controller "ListRoomsCtrl", ($scope, $location, FirechatFactory, AlertService, CommonService, UtilityService) ->

    $scope.user =
      id: null
      name: null

    $scope.rooms = []

    $scope.newRoom =
      name: null
      type: 'public'
      typeOptions: ['public', 'private']

    $scope.pageLoading = true

    $scope.createRoom = ->
      FirechatFactory.createRoom $scope.newRoom.name, $scope.newRoom.type
        .then (roomId) ->
          AlertService.showSuccessMessage 'Room created!', 'SUCCESS'
        .catch (error) ->
          AlertService.showErrorMessage error, 'ERROR'

    $scope.enterRoom = (roomId, roomName) ->
      FirechatFactory.enterRoom roomId, roomName
        .then ->
          $location.url '/room'
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code

    init = ->
      try
        initUser()
        updateListRooms()
        pageReady()
      catch err
        AlertService.showErrorMessage err, 'ERROR'
        CommonService.redirectToMainPage()

    initUser = ->
      user = FirechatFactory.getCurrentUser()
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
          $scope.rooms = UtilityService.convertObjectToArray rooms
        .catch (error) ->
          throw error

    pageReady = ->
      $scope.pageLoading = false

    init()  
    FirechatFactory.bindToFirechat 'user-update', updateListRooms


