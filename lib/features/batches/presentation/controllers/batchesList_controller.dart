import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/batches/data/model/batches_model.dart';

class BatchesListController extends GetxController with SnackBarHelper {
  final Rx<BatchesModel?> data = Rx<BatchesModel?>(null);

  final RxBool lifeCardUpdateController = false.obs;
  final ApiService apiService = ApiService();
  // Observable variables for counts
  var pendingCount = 0.obs;
  var completedCount = 0.obs;
  var abortCount = 0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchBatchesData('');
  }

  Future<void> fetchBatchesData(String? batchId) async {
    try {
      final result = await apiService.fetchBatchesData(batchId!);
      data.value = result;
      updateCounts();
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      data.value = null; // Clear data on error
    }
  }

  void updateCounts() {
    // Assuming your BatchesModel has lists for pending, completed, and aborted batches
    pendingCount.value = data.value?.data!.first.pendingCount! as int;
    completedCount.value = data.value?.data!.first.completedCount! as int;
    abortCount.value = data.value?.data!.first.abortedCount! as int;
  }

  var searchText = "".obs;
  var isSearching = false.obs;

  List<Datum> get filteredData {
    if (searchText.isEmpty) {
      return data.value?.data ?? [];
    } else {
      return (data.value?.data ?? []).where((batch) {
        return batch.batchNo
                ?.toLowerCase()
                .contains(searchText.value.toLowerCase()) ??
            false || batch.batchId.toString().contains(searchText.value);
      }).toList();
    }
  }

  void startSearch() {
    isSearching.value = true;
  }

  void stopSearch() {
    isSearching.value = false;
    searchText.value = "";
  }

  void setSearchText(String text) {
    searchText.value = text;
  }
}