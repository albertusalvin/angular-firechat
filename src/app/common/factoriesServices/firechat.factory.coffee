angular.module "firechatFactory", []
  .factory "FirechatFactory", ($q, GlobalSetting, UtilityService) ->

    FirechatFactory = {}

    firebaseRef = null
    firechatRef = null

    currentRoom =
      id: null
      name: null
    
    FirechatFactory.initialize = ->
      initializeFirebase()
      initializeFirechat()

    FirechatFactory.getAllUsers = ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else
          firebaseRef
            .child 'users'
            .on 'value', (snapshot) ->
              resolve snapshot.val()

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

    FirechatFactory.getRoomMetadata = (roomId) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else
          firechatRef.getRoom roomId, (metadata) ->
            resolve metadata

    FirechatFactory.createRoom = (roomName, roomType) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else
          firechatRef.createRoom roomName, roomType, (roomId) ->
            resolve roomId

    FirechatFactory.enterRoom = (roomId, roomName) ->
      return $q (resolve, reject) ->
        if not firechatRef then reject errorFirechatNotInitialized()
        else if (not roomId) or (not roomName) then reject errorInvalidRoomId()
        else
          firechatRef.enterRoom roomId
          setCurrentRoom roomId, roomName
          resolve()

    FirechatFactory.getUnansweredInvitations = (userid) ->
      return $q (resolve, reject) ->
        if not firechatRef
          reject errorFirechatNotInitialized()
        else
          getInvitations userid
            .then (invites) ->
              arrInvites = UtilityService.convertObjectToArray invites
              unanswered = selectUnansweredInvitations arrInvites
              resolve unanswered

    FirechatFactory.inviteUser = (userId, roomId) ->
      firechatRef.inviteUser userId, roomId

    FirechatFactory.acceptInvitation = (inviteId) ->
      return $q (resolve, reject) ->
        firechatRef.acceptInvite inviteId, (data) ->
          resolve data

    FirechatFactory.declineInvitation = (inviteId) ->
      return $q (resolve, reject) ->
        firechatRef.declineInvite inviteId, (data) ->
          resolve data

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

    FirechatFactory.addRoomMetadataToInvitations = (invitations) ->
      return $q (resolve, reject) ->
        res = []
        for inv in invitations
          getRoomMetaAndPushToArray inv, res
        resolve res

    FirechatFactory.getCurrentUser = ->
      return firechatRef._user

    FirechatFactory.getCurrentRoom = ->
      return currentRoom

    setCurrentRoom = (id, name) ->
      currentRoom.id = id
      currentRoom.name = name

    getRoomMetaAndPushToArray = (inv, arr) ->
      FirechatFactory.getRoomMetadata inv.roomId
        .then (meta) ->
          inv.roomName = meta.name
          arr.push inv
        .catch (error) ->
          inv.roomName = '(Data unavailable)'
          arr.push inv

    getInvitations = (userid) ->
      return $q (resolve, reject) ->
        firebaseRef
          .child 'users'
          .orderByKey().equalTo userid
          .on 'value', (snapshot) ->
            invitations = snapshot.val()[userid]['invites']
            if invitations then resolve invitations
            else resolve()

    selectUnansweredInvitations = (invitations) ->
      unanswered = []
      for i in invitations
        unanswered.push i unless i.status
      return unanswered

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