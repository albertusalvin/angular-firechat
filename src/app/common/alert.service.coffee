angular.module "alertService", []
  .service "AlertService", (toastr) ->

    this.showRegisterSuccessMessage = ->
      toastr.success 'Successfully created user account!', 'Success'

    this.showRegisterErrorMessage = ->
      toastr.error 'Error creating user:', 'Error'

    this.showLoginSuccessMessage = ->
      toastr.success 'Hell yeah, login success!'

    this.showLoginErrorMessage = (errorCode) ->
      if errorCode is 'INVALID_EMAIL'
        toastr.error 'Invalid email. Must follow format: john@example.com', 'Login Failed'
      else if errorCode is 'INVALID_USER'
        toastr.error 'No user with that email was found', 'Login Failed'
      else if errorCode is 'INVALID_PASSWORD'
        toastr.error 'Wrong password', 'Login Failed'
      else
        toastr.error 'Login Failed'

    return this