
angular.module 'angularFirechat'
  .directive 'topbar', ->
    dirObject =
      restrict: 'E'
      templateUrl: 'app/common/directives/topbar.html'
      replace: true
      scope:
        title: '@'

    return dirObject
