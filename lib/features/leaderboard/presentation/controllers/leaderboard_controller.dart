import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/leaderboard/data/Model/leaderboard_details_model.dart';
import 'package:v_ranger/features/settings/presentation/controllers/settings_controller.dart';

class LeaderboardController extends GetxController with SnackBarHelper {
  final Rx<LeaderBoardDetails?> data = Rx<LeaderBoardDetails?>(null);
  final RxBool lifeCardUpdateController = false.obs;
  final ApiService apiService = ApiService();
  final SettingsController settingsController = Get.put(SettingsController());
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Future<void> fetchLeaderboardData() async {
    try {
      final result = await apiService.fetchDriversleaderBoard();
      print(result);
      if (result == null) {
        // Handle unauthorized access by logging out
        // settingsController.logout();
        // showNormalSnackBar('Session expired. Please log in again.');
      } else {
        data.value = result;
      }
      data.value = result;
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      data.value = null; // Clear data on error
    }
  }
}
