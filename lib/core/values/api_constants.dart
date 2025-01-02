import 'dart:io';

abstract class ApiConstants {
  // Default config

  static const connectTimeoutInMs = 60;
  static const receiveTimeoutInMs = 60;
  static const contentTypeJson = 'application/json';
  static const httpMaintenanceModeStatusCode = [
    HttpStatus.badGateway,
    HttpStatus.serviceUnavailable,
    523,
    522
  ];
  static const httpUnauthorizedStatusCode = [HttpStatus.unauthorized];
  static const httpOTPRequired = [101000, 101004, 101003];
  static const httpEmailRequired = [101002];
  static const httpLoginSpecialError = 101006;
  static const httpUnauthorizedIgnoreUrl = [login, logout];
  static const httpMaintenanceIgnoreUrl = ['/auth/version'];
  static const xAuthCodeHeader = 'X-Auth-Code';

  // // API lists
  static const baseUrl = 'http://124.217.247.246/api'; //UAT
  // static const baseUrl = 'https://vranger.com.my/api'; //PROD
  static const login = '/login';
  static const logout = '/logout';
  static const driverprofile = '/driverprofile';
  static const dashboard = '/dashboard';
  static const batches = '/batches';
  static const getbatchdetails = '/getbatchdetails';
  static const getdropdowns = '/getdropdowns';
  static const updatelocation = '/updatelocation';
  static const updatebatchdetailpin = '/updatebatchdetail';
  static const softDeleteBatch = '/updatebatch';
  static const storesurvey = '/storesurvey';
  static const driversleaderboard = '/driversleaderboard';
  static const forgotpassword = '/forgotpassword';
  static const verifyresetcode = '/verifyresetcode';
  static const resetpassword = '/resetpassword';
  static const changepassword = '/changepassword';
  static const statusdropdown = '/statusdropdown';
}
