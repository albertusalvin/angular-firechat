angular.module "localstorageService", []
  .service "LocalStorageService", ->

    this.saveObject = (key, object) ->
      localStorage.setItem(key, JSON.stringify(object))

    this.saveValue = (key, value) ->
      localStorage.setItem(key, value)

    this.get = (key) ->
      item = localStorage.getItem(key)
      try
        parsed = JSON.parse item
        return parsed
      catch error
        return item

    return this