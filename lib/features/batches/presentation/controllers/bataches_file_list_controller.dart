import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/batches/data/model/batch_details_model.dart';
import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart';

class BatachesFileListController extends GetxController with SnackBarHelper {
  final Rx<BatchDetailsList?> data = Rx<BatchDetailsList?>(null);
  final LocationController locationController = Get.put(LocationController());
  final RxBool lifeCardUpdateController = false.obs;
  final ApiService apiService = ApiService();
  var selectedBatchIds = <int>{}.obs; // Store selected batch IDs
  final RxBool isReversed = false.obs;
  final RxBool isSensitive = false.obs;

  // Observable variables for counts
  var pendingCount = 0.obs;
  var completedCount = 0.obs;
  var abortCount = 0.obs;
  var searchText = "".obs;
  var isSearching = false.obs;

  @override
  Future<void> onInit() async {
    checkSensitiveValue();
    super.onInit();
  }

  void onClose() {
    super.onClose(); // Call super.onClose() to ensure proper disposal
  }

  // Toggle selection
  void toggleBatchSelection(int batchId) {
    if (selectedBatchIds.contains(batchId)) {
      selectedBatchIds.remove(batchId); // Unselect
    } else {
      selectedBatchIds.add(batchId); // Select
    }
  }

  // Check if all items are selected
  bool isAllSelected() {
    return selectedBatchIds.length == data.value!.data!.pendingDetails!.length;
  }

  // Toggle select/deselect all items
  void toggleAllSelection() {
    if (isAllSelected()) {
      selectedBatchIds.clear();
    } else {
      selectedBatchIds.addAll(
          data.value!.data!.pendingDetails!.map((batch) => batch.id!).toList());
    }
  }

  Future<void> fetchBatchDetailsList(String batchId, String search,
      String driverLatitude, String driverLongitude) async {
    try {
      final result = await apiService.fetchBatchDetailsList(
        batchId,
        search,
        driverLatitude,
        driverLongitude,
      );
      data.value = result;
      updateCounts();
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      data.value = null; // Clear data on error
    }
  }

  Future<bool> checkSensitiveValue() async {
    final prefs = await SharedPreferences.getInstance();
    String? detailsString = prefs.getString('details');

    // Check if the detailsString is not null before proceeding
    if (detailsString == null) {
      throw Exception('Details string not found in SharedPreferences.');
    }

    Map<String, dynamic> details = jsonDecode(detailsString);
    String sensitiveValue = details['sensitive'].toString();

    // Check if sensitiveValue is "yes" or "no"
    if (sensitiveValue.toLowerCase() == "yes") {
      isSensitive.value = true;
      return true;
    } else if (sensitiveValue.toLowerCase() == "no") {
      isSensitive.value = false;
      return false;
    } else {
      throw Exception('Invalid value for sensitive: $sensitiveValue');
    }
  }

  Future<void> updateBatchPin(
    String? batchId,
    String? batchfileId,
    String? action,
  ) async {
    try {
      final result = await apiService.updateBatchPin(batchfileId!, action!);
      final responseData = jsonDecode(result!.body);
      final message = responseData['message'] ?? 'Unknown error';
      print("batchId:::: $batchId");
      fetchBatchDetailsList(batchId!, searchText.value, '', '');
      showNormalSnackBar(message);
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      data.value = null; // Clear data on error
    }
  }

  void updateCounts() {
    // Assuming your BatchesModel has lists for pending, completed, and aborted batches
    pendingCount.value = data.value?.data!.pendingCount! as int;
    completedCount.value = data.value?.data!.completedCount! as int;
    abortCount.value = data.value?.data!.abortedCount! as int;
  }

  void startSearch() {
    isSearching.value = true;
  }

  void stopSearch() {
    isSearching.value = false;
    searchText.value = "";
  }

  void setSearchText(String text, String batchId) {
    searchText.value = text;
    fetchBatchDetailsList(batchId, searchText.value, '', '');
  }
}
