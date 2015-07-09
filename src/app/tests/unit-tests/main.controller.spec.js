'use strict';

describe('MainController', function() {

  beforeEach(module('angularFirechat'));

  beforeEach(inject(function ($rootScope, $controller, $httpBackend, FirebaseFactory, FirechatFactory) {
    this.scope = $rootScope.$new();
    this.controller = $controller('MainCtrl', {
      $scope: this.scope
    });
    this.httpBackend = $httpBackend;
    this.FirebaseFactory = FirebaseFactory;
    this.FirechatFactory = FirechatFactory;
  }));

  afterEach(function () {
    this.httpBackend.verifyNoOutstandingExpectation();
    this.httpBackend.verifyNoOutstandingRequest();
  });

  /*
  describe('instantiation process', function () {
    it('should initiate FirebaseFactory and FirechatFactory', function () {
      expect(this.FirebaseFactory.initialize).toBeDefined();
      expect(this.FirechatFactory.initialize).toBeDefined();
    });
  });
  */
});
