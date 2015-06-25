angular.module "commonService", []
  .service "CommonService", ($timeout, $location, GlobalSetting) ->

    this.redirectToMainPage = ->
      $timeout( ->
        $location.url '/'
      , GlobalSetting.errMsgTimeout)

    return this