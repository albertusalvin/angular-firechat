angular.module "firebaseFactory", []
  .factory "FirebaseFactory", ($q, GlobalSetting) ->

    FirebaseFactory = {}
    FirebaseFactory.isInitialized = false

    firebaseRef = null

    FirebaseFactory.initialize = ->
      initializeFirebase()
      FirebaseFactory.isInitialized = true

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

    FirebaseFactory.storeUserData = (authData) ->
      def = $q.defer()

      if firebaseRef
        getFirechatUserByUid authData.uid
          .then (user) ->
            if user is 0 then storeUserData def, authData
            else def.resolve authData
          .catch (error) -> def.reject error
      else rejectFirebaseNotInitialized def

      return def.promise

    initializeFirebase = ->
      firebaseRef = new Firebase GlobalSetting.firebaseAppUrl

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

    storeUserData = (deferred, authData) ->
      newUser =
        'provider': authData.provider
        'email': authData[authData.provider].email

      firebaseRef
        .child(GlobalSetting.tableNameFirechatUsers).child(authData.uid)
        .set newUser, (error) ->
          if error then deferred.reject error
          else deferred.resolve authData

    getFirechatUserByUid = (uid) ->
      def = $q.defer()

      if firebaseRef
        firebaseRef
          .child GlobalSetting.tableNameFirechatUsers
          .orderByKey().startAt(uid).endAt(uid)
          .on 'value', (snapshot) ->
            if snapshot.numChildren() is 1
              def.resolve snapshot.val()
            else 
              def.resolve 0
      else
        rejectFirebaseNotInitialized def

      return def.promise

    rejectFirebaseNotInitialized = (deferred) ->
      deferred.reject { code: 'FIREBASE UNINITIALIZED', message: 'Firebase is not initialized' }

    return FirebaseFactory