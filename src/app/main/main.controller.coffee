angular.module "angularFirechat"
  .controller "MainCtrl", ($scope, $q, toastr, FirebaseFactory, GlobalSetting) ->

    $scope.login =
      email: null
      password: null

    $scope.register =
      email: null
      password: null
      confirmPassword: null
      username: null


    $scope.currentUser = "No user login"

    firebase = null

    $scope.registerUser = ->
      regData =
        email: $scope.register.email
        password: $scope.register.password
        
      firebase.createUser regData, registerUserCallback

    $scope.loginUser = ->
      firebase.authWithPassword $scope.login, loginUserCallback

    initiateFirebase = ->
      firebase = new Firebase(GlobalSetting.firebaseAppUrl)

    registerUserCallback = (error, userData) ->
      if error
        showRegisterUserErrorMessage()
      else
        recordNewUser userData.uid, $scope.register.email, $scope.register.username
          .then ->
            resetRegisterModel()
            showRegisterUserSuccessMessage()

    recordNewUser = (userId, email, userName) ->
      def = $q.defer()
      
      newUser =
        'uid': userId
        'email': email
        'username': userName
      
      firebase.child(GlobalSetting.tableNameFirechatUsers).push newUser, ->
        def.resolve()

      return def.promise

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
        username: null
        
    resetLoginModel = ->
      $scope.login =
        email: null
        password: null

    initiateFirebase()

