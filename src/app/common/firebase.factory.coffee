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