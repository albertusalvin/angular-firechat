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

    $scope.registerUser = ->
      firebase.createUser $scope.register, registerUserCallback

    $scope.loginUser = ->
      firebase.authWithPassword $scope.login, loginUserCallback

    registerUserCallback = (error, userData) ->
      if error
        showRegisterUserErrorMessage()
      else
        resetRegisterModel()
        showRegisterUserSuccessMessage()

    loginUserCallback = (error, authData) ->
      if error
        showLoginErrorMessage error.code
      else
        updateCurrentUser(authData)
        showLoginSuccessMessage()
        resetLoginModel()
    updateCurrentUser = (authData) ->
      $scope.currentUser = authData[authData.provider].email

    showRegisterUserSuccessMessage = ->
      toastr.success 'Successfully created user account!', 'Success'

    showRegisterUserErrorMessage = ->
      toastr.error 'Error creating user:', 'Error'

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

    resetRegisterModel = ->
      $scope.register =
        email: null
        password: null
        confirmPassword: null
        
    resetLoginModel = ->
      $scope.login =
        email: null
        password: null


