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

  // API lists
  static const baseUrl = 'http://124.217.247.246/api';
  static const login = '/login';
  static const logout = '/logout';
  static const dashboard = '/dashboard';
  static const batches = '/batches';
}
