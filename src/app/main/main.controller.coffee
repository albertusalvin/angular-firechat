angular.module "angularFirechat"
  .controller "MainCtrl", ($scope, toastr, GlobalSetting) ->


    

    $scope.register = 
      email: null
      password: null
      confirmPassword: null

    firebase = new Firebase(GlobalSetting.firebaseAppUrl)

    $scope.createUser = ->
      firebase.createUser $scope.register, createUserCallback

    createUserCallback = (error, userData) ->
      if error
        toastr.error 'Error creating user:', error
      else
        resetRegister()
        toastr.success 'Successfully created user account with uid: ' + userData.uid, 'Success'

    resetRegister = ->
      $scope.register =
        email: null
        password: null
        confirmPassword: null

