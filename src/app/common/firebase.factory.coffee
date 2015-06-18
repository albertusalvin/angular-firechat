angular.module "firebaseFactory", []
  .factory "FirebaseFactory", ($q, GlobalSetting) ->

    FirebaseFactory = {}
    firebaseRef = null

    FirebaseFactory.initiateFirebase = ->
      firebaseRef = new Firebase(GlobalSetting.firebaseAppUrl)

    FirebaseFactory.createUser = (email, password) ->
      def = $q.defer()
      
      if firebaseRef then createUser def, email, password 
      else rejectFirebaseNotInitialized def
      
      return def.promise

    FirebaseFactory.loginUser = (email, password) ->
      def = $q.defer()

      if firebaseRef then loginUser def, email, password
      else rejectFirebaseNotInitialized def

      return def.promise

    FirebaseFactory.recordNewFirechatUser = (uid, email, username) ->
      def = $q.defer()
      
      if firebaseRef
        newUser =
          'uid': uid
          'email': email
          'username': username
        
        firebaseRef
          .child GlobalSetting.tableNameFirechatUsers
          .push newUser, -> def.resolve()
      else
        rejectFirebaseNotInitialized def

      return def.promise

    FirebaseFactory.getFirechatUserByUid = (uid) ->
      def = $q.defer()

      if firebaseRef
        result =
          'key': null
          'value': null

        tableFirechatUsers = firebaseRef.child GlobalSetting.tableNameFirechatUsers
        tableFirechatUsers
          .orderByChild 'uid'
          .startAt uid
          .endAt uid
          .on 'value', (snapshot) ->
            for key, value of snapshot.val()
              result.key = key
              result.value = value
            def.resolve result
      else
        rejectFirebaseNotInitialized def

      return def.promise

      return def.promise
    createUser = (deferred, email, password) ->
      regData =
        'email': email
        'password': password

      firebaseRef.createUser regData, (error, userData) ->
        if error
          deferred.reject error
        else
          deferred.resolve userData

    loginUser = (deferred, email, password) ->
      loginData =
        'email': email
        'password': password

      firebaseRef.authWithPassword loginData, (error, authData) ->
        if error
          deferred.reject error
        else
          deferred.resolve authData

    rejectFirebaseNotInitialized = (deferred) ->
      deferred.reject { code: 'FIREBASE UNINITIALIZED', message: 'Firebase is not initialized' }

    return FirebaseFactory