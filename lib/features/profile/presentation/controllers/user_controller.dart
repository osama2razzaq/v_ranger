import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:v_ranger/features/login/data/model/userDetails_model.dart';

class UserController extends GetxController {
  var userDetails = UserDetails(
    accessToken: '',
    tokenType: '',
    details: Details(
      id: 0,
      username: '',
      name: '',
      phoneNumber: '',
      permissions: [],
      icNumber: '',
      appLogin: 0,
      sensitive: '',
      supervisor: null,
      status: 0,
      companyId: 0,
      createdAt: '',
      updatedAt: '',
      latitude: '',
      longitude: '',
      devicetoken: '',
    ),
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadUserDetails();
  }

  void saveUserDetails(UserDetails user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userDetails', jsonEncode(user.toJson()));
    userDetails.value = user;
  }

  void loadUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetailsString = prefs.getString('userDetails');
    if (userDetailsString != null) {
      userDetails.value = UserDetails.fromJson(jsonDecode(userDetailsString));
    }
  }

  void clearUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userDetails');
    userDetails.value = UserDetails(
      accessToken: '',
      tokenType: '',
      details: Details(
        id: 0,
        username: '',
        name: '',
        phoneNumber: '',
        permissions: [],
        icNumber: '',
        appLogin: 0,
        sensitive: '',
        supervisor: null,
        status: 0,
        companyId: 0,
        createdAt: '',
        updatedAt: '',
        latitude: '',
        longitude: '',
        devicetoken: '',
      ),
    );
  }
}
