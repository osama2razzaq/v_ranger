import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/dashboard/data/Model/dashboard_model.dart';
import 'package:v_ranger/features/settings/presentation/controllers/settings_controller.dart';

class HomeController extends GetxController with SnackBarHelper {
  final Rx<DashboardModel?> data = Rx<DashboardModel?>(null);
  final SettingsController settingsController = Get.put(SettingsController());
  final RxBool lifeCardUpdateController = false.obs;
  final ApiService apiService = ApiService();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  // Function to fetch and handle dashboard data
  Future<void> fetchAndHandleDashboardData() async {
    try {
      final result = await apiService.fetchDashboardData();
      if (result == null) {
        // Handle unauthorized access by logging out
        // settingsController.logout();
        // showNormalSnackBar('Session expired. Please log in again.');
      } else {
        data.value = result;
      }
    } catch (e) {
      //  showNormalSnackBar('Failed to load data: $e');
      data.value = null; // Clear data on error
    }
  }
}
