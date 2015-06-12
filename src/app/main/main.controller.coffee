angular.module "angularFirechat"
  .controller "MainCtrl", ($scope, toastr, GlobalSetting) ->

    $scope.login =
      email: null
      password: null

    $scope.register =
      email: null
      password: null
      confirmPassword: null

    $scope.currentUser = "No user login"

    firebase = new Firebase(GlobalSetting.firebaseAppUrl)

    $scope.createUser = ->
      firebase.createUser $scope.register, createUserCallback

    createUserCallback = (error, userData) ->
      if error
        toastr.error 'Error creating user:', error
      else
        resetRegisterModel()
        toastr.success 'Successfully created user account with uid: ' + userData.uid, 'Success'

    resetRegisterModel = ->
      $scope.register =
        email: null
        password: null
        confirmPassword: null

    $scope.loginUser = ->
      firebase.authWithPassword $scope.login, loginUserCallback

    loginUserCallback = (error, authData) ->
      if error
        showLoginErrorMessage error.code
      else
        showLoginSuccessMessage()
        resetLoginModel()
        
        $scope.currentUser = authData[authData.provider].email

    showLoginSuccessMessage = ->
      toastr.success 'Hell yeah, login success!'

    showLoginErrorMessage = (errorCode) ->
      if errorCode is 'INVALID_EMAIL'
        toastr.error 'Invalid email. Must follow format: john@example.com', 'Login Failed'
      else if errorCode is 'INVALID_USER'
        toastr.error 'No user with that email was found', 'Login Failed'
      else if errorCode is 'INVALID_PASSWORD'
        toastr.error 'Wrong password', 'Login Failed'
      else
        toastr.error 'Login Failed'    

    resetLoginModel = ->
      $scope.login =
        email: null
        password: null


