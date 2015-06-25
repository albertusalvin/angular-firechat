angular.module "firechatFactory", []
  .factory "FirechatFactory", ($q, GlobalSetting) ->

    FirechatFactory = {}

    firebaseRef = null
    firechatRef = null
    
    FirechatFactory.initialize = ->
      initializeFirebase()
      initializeFirechat()

    FirechatFactory.getUser = ->
      return firechatRef._user

    FirechatFactory.setUser = (authData) ->
      uid = authData.uid
      username = authData[authData.provider].email.replace(/@.*/, '')

      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else if (not uid) or (not username)
          reject errorInvalidAuthData()
        else
          firechatRef.setUser uid, username, (user) ->
            resolve user

    FirechatFactory.getRoomListByUser = (userid) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else
          firebaseRef
            .child 'users'
            .orderByKey().equalTo userid
            .on 'value', (snapshot) ->
              resolve snapshot.val()[userid].rooms

    FirechatFactory.createRoom = (roomName, roomType) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else
          firechatRef.createRoom roomName, roomType, (roomId) ->
            resolve roomId

    FirechatFactory.enterRoom = (roomId) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else if not roomId
          reject errorInvalidRoomId()
        else
          firechatRef.enterRoom roomId
          resolve()

    FirechatFactory.getMessages = (roomId) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else
          firebaseRef
            .child 'room-messages'
            .orderByKey().equalTo roomId
            .on 'value', (snapshot) ->
              if snapshot.val()
                resolve snapshot.val()[roomId]
              else
                resolve()

    FirechatFactory.sendMessage = (roomId, message, messageType = "default") ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else if (not roomId) or (not message)
          reject errorInvalidMessage()
        else
          firechatRef.sendMessage roomId, message, messageType, (data) ->
            resolve data

    FirechatFactory.bindToFirechat = (eventID, callback) ->
      firechatRef.on eventID, callback

    initializeFirebase = ->
      firebaseRef = new Firebase GlobalSetting.firebaseAppUrl + '/' + GlobalSetting.tableNameFirechat

    initializeFirechat = ->
      firechatRef = new Firechat firebaseRef

    errorFirechatNotInitialized = ->
      return { code: null, message: 'Firechat is uninitialized' }

    errorInvalidAuthData = ->
      return { code: null, message: 'Invalid authdata' }

    errorInvalidRoomId = ->
      return { code: null, message: 'Invalid room ID' }

    errorInvalidMessage = ->
      return { code: null, message: 'Invalid message' }

    return FirechatFactory