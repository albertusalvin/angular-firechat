angular.module 'utilityService', []
  .service 'UtilityService', ->

    this.convertObjectToArray = (obj, keyAlias) ->
      arr = []

      if keyAlias
        for key, value of obj
          value[keyAlias] = key
          arr.push value
      else
        for key, value of obj
          arr.push value

      return arr

    this.sortByAttribute = (arr, attributeName) ->
      return arr.sort (a, b) ->
        return a[attributeName] - b[attributeName]

    this.sortByAttributeDescending = (arr, attributeName) ->
      return arr.sort (a, b) ->
        return b[attributeName] - a[attributeName]

    return this