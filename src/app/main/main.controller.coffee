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
      regData =
        email: $scope.register.email
        password: $scope.register.password

      FirebaseFactory.createUser $scope.register.email, $scope.register.password
        .then (userData) ->
          console.log 'Sukses euy! Alhamdulilaah....'
          console.log userData
          resetRegisterModel()
          showRegisterUserSuccessMessage()
        .catch showRegisterUserErrorMessage

    $scope.loginUser = ->
      FirebaseFactory.loginUser $scope.login.email, $scope.login.password
        .then (authData) ->
          updateCurrentUser(authData)
          showLoginSuccessMessage()
          resetLoginModel()
          console.log 'Ya ampuun...sukses lagi! Puji Tuhan Alhamdulilaah halleluya!'
          console.log authData
        .catch (error) ->
          showLoginErrorMessage error.code

    $scope.createNewRoom = ->
      # Under Construction

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
        username: null
        
    resetLoginModel = ->
      $scope.login =
        email: null
        password: null

    FirebaseFactory.initiateFirebase()

