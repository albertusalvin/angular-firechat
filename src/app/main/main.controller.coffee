angular.module "angularFirechat"
  .controller "MainCtrl", ($scope, $location, FirebaseFactory, FirechatFactory, AlertService, LocalStorageService) ->

    $scope.login =
      email: null
      password: null

    $scope.register =
      email: null
      password: null
      confirmPassword: null
      username: null  # This attribute is currently unused

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
          LocalStorageService.saveObject 'userdata', user
          resetLoginModel()
          AlertService.showLoginSuccessMessage()
          $location.url '/listRooms'
        .catch (error) ->
          AlertService.showErrorMessage error.message, error.code

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


