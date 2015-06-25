angular.module "alertService", []
  .service "AlertService", (toastr) ->

    this.showRegisterSuccessMessage = ->
      toastr.success 'Successfully created user account!', 'Success'

    this.showLoginSuccessMessage = ->
      toastr.success 'Hell yeah, login success!'

    this.showErrorMessage = (errorMesssage, errorTitle) ->
      if errorMesssage and errorTitle
        toastr.error errorMesssage, errorTitle.replace(/_/g, ' ')
      else if errorMesssage
        toastr.error errorMesssage
      else
        toastr.error 'Unknown error', 'ERROR'

    this.showSuccessMessage = (successMessage, successTitle) ->
      if successMessage and successTitle
        toastr.success successMessage, successTitle.replace(/_/g, ' ')
      else if successMessage
        toastr.success successMessage
      else
        toastr.success 'Unknown success', 'SUCCESS'

    return this