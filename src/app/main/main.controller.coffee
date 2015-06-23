angular.module "angularFirechat"
  .controller "MainCtrl", ($scope, FirebaseFactory, FirechatFactory, AlertService) ->

    $scope.login =
      email: null
      password: null

    $scope.register =
      email: null
      password: null
      confirmPassword: null
      username: null  # This attribute is currently unused

    $scope.newRoom =
      name: null
      type: 'public'
      typeOptions: ['public', 'private']

    $scope.registerUser = ->
      FirebaseFactory.createUser $scope.register.email, $scope.register.password
        .then (userData) ->
          resetRegisterModel()
          AlertService.showRegisterSuccessMessage()
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code

    $scope.loginUser = ->
      FirebaseFactory.loginUser $scope.login.email, $scope.login.password
        .then FirebaseFactory.storeUserData
        .then FirechatFactory.setUser
        .then (user) ->
          console.log 'user data'
          console.log user

          resetLoginModel()
          AlertService.showLoginSuccessMessage()
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code

    $scope.createRoom = ->
      FirechatFactory.createRoom $scope.newRoom.name, $scope.newRoom.type
        .then (roomId) ->
          console.log 'room generated'
          console.log roomId

    resetRegisterModel = ->
      $scope.register =
        email: null
        password: null
        confirmPassword: null
        username: null
        
    resetLoginModel = ->
      $scope.login =
        email: null
        password: null

    FirebaseFactory.initialize()
    FirechatFactory.initialize()


