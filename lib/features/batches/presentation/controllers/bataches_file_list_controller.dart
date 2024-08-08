import 'dart:convert';

import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/batches/data/model/batch_details_model.dart';

class BatachesFileListController extends GetxController with SnackBarHelper {
  final Rx<BatchDetailsList?> data = Rx<BatchDetailsList?>(null);

  final RxBool lifeCardUpdateController = false.obs;
  final ApiService apiService = ApiService();
  // Observable variables for counts
  var pendingCount = 0.obs;
  var completedCount = 0.obs;
  var abortCount = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  void onClose() {
    super.onClose(); // Call super.onClose() to ensure proper disposal
  }

  Future<void> fetchBatchesData(String? batchId) async {
    try {
      final result = await apiService.fetchBatchDetailsList(batchId!);
      data.value = result;
      updateCounts();
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      data.value = null; // Clear data on error
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
      fetchBatchesData(batchId);
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

  var searchText = "".obs;
  var isSearching = false.obs;
}
