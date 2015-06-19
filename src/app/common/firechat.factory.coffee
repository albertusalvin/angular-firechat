angular.module "firechatFactory", []
  .factory "FirechatFactory", ($q, GlobalSetting) ->

    FirechatFactory = {}
    firebaseRef = null
    firechatRef = null

    FirechatFactory.initialize = ->
      initializeFirebase()
      initializeFirechat()

    initializeFirebase = ->
      firebaseRef = new Firebase GlobalSetting.firebaseAppUrl + '/' + GlobalSetting.tableNameFirechat

    initializeFirechat = ->
      firechatRef = new Firechat firebaseRef

    return FirechatFactory