angular.module "angularFirechat"
  .controller "MainCtrl", ($scope, toastr, FirebaseFactory, AlertService, GlobalSetting) ->

    $scope.login =
      email: null
      password: null

    $scope.register =
      email: null
      password: null
      confirmPassword: null
      username: null

    $scope.currentUser = "No user login"

    $scope.registerUser = ->
      FirebaseFactory.createUser $scope.register.email, $scope.register.password
        .then (userData) ->
          resetRegisterModel()
          AlertService.showRegisterUserSuccessMessage()
        .catch ->
          AlertService.showRegisterUserErrorMessage()

    $scope.loginUser = ->
      FirebaseFactory.loginUser $scope.login.email, $scope.login.password
        .then (authData) ->
          updateCurrentUser(authData)
          resetLoginModel()
          AlertService.showLoginSuccessMessage()
        .catch (error) ->
          AlertService.showLoginErrorMessage error.code

    $scope.createNewRoom = ->
      # Under Construction

    updateCurrentUser = (authData) ->
      $scope.currentUser = authData[authData.provider].email

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

    FirebaseFactory.initiateFirebase()

