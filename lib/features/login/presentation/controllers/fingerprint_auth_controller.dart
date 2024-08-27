import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:local_auth/local_auth.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart'; // For local storage

class FingerprintAuthController extends GetxController with SnackBarHelper {
  final LocalAuthentication auth =
      LocalAuthentication(); // Initialize local auth
  var isFingerprintEnabled = false.obs;
  RxString username = ''.obs;
  RxString name = ''.obs;
  RxString phoneNo = ''.obs;

  final LocationController locationController = Get.put(LocationController());

  // Instance of ApiService
  final ApiService apiService =
      ApiService(); // Replace with your actual base URL

  // Device token (for demonstration purposes, this should be retrieved from your device)
  final String deviceToken = '';
  void onInit() async {
    super.onInit();
    await getUserDetails();
    //verifyFingerprint(); // Check initial fingerprint status on init
  }

// Check if fingerprint is enabled
  Future<void> checkFingerprintStatus() async {
    final prefs = await SharedPreferences.getInstance();

    isFingerprintEnabled.value = prefs.getBool('isFingerprintEnabled') ?? false;
  }

  Future<void> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    final _username = prefs.get('username');
    final _name = prefs.get('name');
    final _phoneNumber = prefs.get('phone_number');
    username.value = _username.toString();
    phoneNo.value = _phoneNumber.toString();
    name.value = _name.toString();
  }

  Future<void> verifyFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    bool fingerprintEnabled = prefs.getBool('isFingerprintEnabled') ?? false;

    if (fingerprintEnabled) {
      try {
        bool canCheckBiometrics = await auth.canCheckBiometrics;
        bool isAuthenticated = await auth.authenticate(
            localizedReason: 'Please authenticate to access the app',
            options: AuthenticationOptions());

        if (!canCheckBiometrics || !isAuthenticated) {
          // Get.offAllNamed(Routes.login);
        } else {
          Get.offAllNamed(Routes.dashboard);
        }
      } catch (e) {
        showErrorSnackBar('An error occurred during authentication: $e');
        //    Get.offAllNamed(Routes.login);
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
