import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/Survey/data/Model/drop_down_mode.dart';

class SurveyFormController extends GetxController with SnackBarHelper {
  final Rx<DropdownModel?> dropDownData = Rx<DropdownModel?>(null);
  // Observable lists for dropdowns
  var ownershipItems = <String>[].obs;
  var occupancyStatusItems = <String>[].obs;
  var natureOfBusinessItems = <String>[].obs;
  var drCodeItems = <String>[].obs;
  var propertyTypeItems = <String>[].obs;
  var classificationItems = <String>[].obs;

  var isWaterBillVisible = false.obs;
  var isWaterMeterVisible = false.obs;
  var isCorrectAddressVisible = false.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    fetchDropdownList();
    super.onInit();
  }

  Future<void> fetchDropdownList() async {
    try {
      final result = await apiService.fetchDropDownData();
      dropDownData.value = result;
      // Assuming that result contains lists for the dropdowns
      ownershipItems.value =
          result?.ownerships?.map((item) => item.ownershipname!).toList() ?? [];

      occupancyStatusItems.value = result?.occupancyStatus
              ?.map((item) => item.occupancyStatusName!)
              .toList() ??
          [];

      natureOfBusinessItems.value = result?.natureOfBussinessCode
              ?.map((item) => item.natureOfBussinessCodeName!)
              .toList() ??
          [];
      drCodeItems.value =
          result?.drCode?.map((item) => item.drCodeName!).toList() ?? [];
      propertyTypeItems.value = result?.propertyType
              ?.map((item) => item.propertyTypeName!)
              .toList() ??
          [];
      classificationItems.value = result?.classification
              ?.map((item) => item.classificationName!)
              .toList() ??
          [];
      print("fetchDropdownList:: $result");
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      dropDownData.value = null; // Clear data on error
    }
  }
}
