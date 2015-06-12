angular.module "angularFirechat"
  .controller "MainCtrl", ($scope, toastr) ->


    

    $scope.register = 
      email: null
      password: null
      confirmPassword: null

    ref = new Firebase("https://sweltering-inferno-4271.firebaseio.com")

    $scope.createUser = ->
      ref.createUser $scope.register, createUserCallback

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

