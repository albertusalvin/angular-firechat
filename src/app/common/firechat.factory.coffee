angular.module "firechatFactory", []
  .factory "FirechatFactory", ($q, GlobalSetting) ->

    FirechatFactory = {}
    firebaseRef = null
    firechatRef = null

    FirechatFactory.initialize = ->
      initializeFirebase()
      initializeFirechat()

    FirechatFactory.setUser = (userid, username) ->
      return $q (resolver, rejector) ->
        if firechatRef then setUser resolver, userid, username
        else rejectFirechatNotInitialized rejector

    FirechatFactory.createRoom = (roomname, roomtype) ->
      return $q (resolver, rejector) ->
        if firechatRef then createRoom resolver, roomname, roomtype
        else rejectFirechatNotInitialized rejector

    initializeFirebase = ->
      firebaseRef = new Firebase GlobalSetting.firebaseAppUrl + '/' + GlobalSetting.tableNameFirechat

    initializeFirechat = ->
      firechatRef = new Firechat firebaseRef

    setUser = (resolve, userid, username) ->
      firechatRef.setUser userid, username, (user) ->
        resolve user

    createRoom = (resolve, roomName, roomType) ->
      firechatRef.createRoom roomName, roomType, (roomId) ->
        resolve roomId

    rejectFirechatNotInitialized = (reject) ->
      reject { code: 'FIRECHAT UNINITIALIZED', message: 'Firechat is uninitialized' }

    return FirechatFactory