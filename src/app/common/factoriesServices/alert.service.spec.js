'use strict';

describe('AlertService', function() {

  beforeEach(module('alertService', 'toastr'));

  beforeEach(inject(function (AlertService, toastr) {
    this.AlertService = AlertService;
    this.toastr = toastr;
  }));

  it('should be defined', function () {
    expect(this.AlertService).toBeDefined();
  });

  describe('function showRegisterSuccessMessage and function showLoginSuccessMessage', function () {
    
    it('should be defined', function () {
      expect(this.AlertService.showRegisterSuccessMessage).toBeDefined();
      expect(this.AlertService.showLoginSuccessMessage).toBeDefined();
    });

    it('should call toastr.success()', function () {
      spyOn(this.toastr, 'success').and.callThrough();
      this.AlertService.showRegisterSuccessMessage();
      expect(this.toastr.success).toHaveBeenCalled();
    });
  });

  describe('function showLoginSuccessMessage', function () {

    it('should be defined', function () {
      expect(this.AlertService.showLoginSuccessMessage).toBeDefined();
    });

    it('should call toastr.success()', function () {
      spyOn(this.toastr, 'success').and.callThrough();
      this.AlertService.showLoginSuccessMessage();
      expect(this.toastr.success).toHaveBeenCalled();
    });
  });

  describe('function showErrorMessage', function () {

    it('should be defined', function () {
      expect(this.AlertService.showErrorMessage).toBeDefined();
    });

    it('when message title is supplied, it should replace underscore with white space', function () {
      var message = 'This is message',
          title = 'THIS_IS_TITLE';

      spyOn(this.toastr, 'error').and.callThrough();
      this.AlertService.showErrorMessage(message, title);
      expect(this.toastr.error).toHaveBeenCalledWith(message, 'THIS IS TITLE');
    });

    it('should still works if only the message is supplied (no title)', function () {
      spyOn(this.toastr, 'error').and.callThrough();
      this.AlertService.showErrorMessage('this is message');
      expect(this.toastr.error).toHaveBeenCalled();
    });

    it('should still works if neither message nor title is supplied', function () {
      spyOn(this.toastr, 'error').and.callThrough();
      this.AlertService.showErrorMessage();
      expect(this.toastr.error).toHaveBeenCalled();      
    });
  });

  describe('function showSuccessMessage', function () {

    it('should be defined', function () {
      expect(this.AlertService.showSuccessMessage).toBeDefined();
    });

    it('when message title is supplied, it should replace underscore with white space', function () {
      var message = 'This is message',
          title = 'THIS_IS_TITLE';

      spyOn(this.toastr, 'success').and.callThrough();
      this.AlertService.showSuccessMessage(message, title);
      expect(this.toastr.success).toHaveBeenCalledWith(message, 'THIS IS TITLE');
    });

    it('should still works if only the message is supplied (no title)', function () {
      spyOn(this.toastr, 'success').and.callThrough();
      this.AlertService.showSuccessMessage('this is message');
      expect(this.toastr.success).toHaveBeenCalled();
    });

    it('should still works if neither message nor title is supplied', function () {
      spyOn(this.toastr, 'success').and.callThrough();
      this.AlertService.showSuccessMessage();
      expect(this.toastr.success).toHaveBeenCalled();      
    });
  });
});
