import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/profile/data/model/profile_model.dart';
import 'package:v_ranger/features/settings/presentation/controllers/settings_controller.dart';

class ProfileController extends GetxController with SnackBarHelper {
  final Rx<ProfileModel?> data = Rx<ProfileModel?>(null);
  final SettingsController settingsController = Get.put(SettingsController());
  final RxBool lifeCardUpdateController = false.obs;
  final ApiService apiService = ApiService();

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      final result = await apiService.fetchProfileData();
      if (result == null) {
        // Handle unauthorized access by logging out
        settingsController.logout();
        showNormalSnackBar('Session expired. Please log in again.');
      } else {
        data.value = result;
      }
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');

      data.value = null; // Clear data on error
    }
  }
}
