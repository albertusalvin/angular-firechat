angular.module "alertService", []
  .service "AlertService", (toastr) ->

    this.showRegisterSuccessMessage = ->
      toastr.success 'Successfully created user account!', 'Success'

    this.showLoginSuccessMessage = ->
      toastr.success 'Hell yeah, login success!'

    this.showErrorMessage = (errorMesssage, errorTitle) ->
      if errorMesssage and errorTitle
        toastr.error errorMesssage, errorTitle.replace(/_/g, ' ')
      else
        toastr.error 'Unknown error', 'ERROR'

    return this