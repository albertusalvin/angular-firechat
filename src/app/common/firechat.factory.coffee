angular.module "firechatFactory", []
  .factory "FirechatFactory", ($q, GlobalSetting) ->

    FirechatFactory = {}
    FirechatFactory.isInitialized = false

    firebaseRef = null
    firechatRef = null
    
    FirechatFactory.initialize = ->
      initializeFirebase()
      initializeFirechat()
      FirechatFactory.isInitialized = true

    FirechatFactory.setUser = (authData) ->
      uid = authData.uid
      username = authData[authData.provider].email.replace(/@.*/, '')

      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized
        else if (not uid) or (not username)
          reject errorInvalidAuthData
        else
          firechatRef.setUser uid, username, (user) ->
            resolve user

    FirechatFactory.createRoom = (roomName, roomType) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized
        else
          firechatRef.createRoom roomName, roomType, (roomId) ->
            resolve roomId

    FirechatFactory.getRoomListByUser = (userid) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized
        else
          firebaseRef
            .child 'users'
            .orderByKey().equalTo userid
            .on 'value', (snapshot) ->
              resolve snapshot.val()[userid].rooms

    FirechatFactory.bindToFirechat = (eventID, callback) ->
      firechatRef.on eventID, callback

    initializeFirebase = ->
      firebaseRef = new Firebase GlobalSetting.firebaseAppUrl + '/' + GlobalSetting.tableNameFirechat

    initializeFirechat = ->
      firechatRef = new Firechat firebaseRef

    errorFirechatNotInitialized = ->
      return { code: 'FIRECHAT UNINITIALIZED', message: 'Firechat is uninitialized' }

    errorInvalidAuthData = ->
      return { code: 'INVALID AUTHDATA', message: 'Unexpected authdata format' }



    return FirechatFactory