import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/Survey/data/Model/drop_down_mode.dart';

class SurveyFormController extends GetxController with SnackBarHelper {
  final Rx<DropdownModel?> dropDownData = Rx<DropdownModel?>(null);

  // Controllers for text fields
  final waterBillController = TextEditingController();
  final waterMeterController = TextEditingController();
  final correctAddressController = TextEditingController();
  final occupierNameController = TextEditingController();
  final occupierPhoneNumberController = TextEditingController();
  final occupierEmailController = TextEditingController();
  final shopNameController = TextEditingController();
  final addRemarkController = TextEditingController();

  // lists for FocusNode for go to next TextField
  final FocusNode waterBillFocus = FocusNode();
  final FocusNode waterMeterFocus = FocusNode();
  final FocusNode correctAddressFocus = FocusNode();
  final FocusNode occupierNameFocus = FocusNode();
  final FocusNode occupierPhoneNumberFocus = FocusNode();
  final FocusNode occupierEmailFocus = FocusNode();
  final FocusNode shopNameFocus = FocusNode();
  final FocusNode addRemarkFocus = FocusNode();

  // Observable lists for dropdowns
  var ownershipItems = <String>[].obs;
  var occupancyStatusItems = <String>[].obs;
  var natureOfBusinessItems = <String>[].obs;
  var drCodeItems = <String>[].obs;
  var propertyTypeItems = <String>[].obs;
  var classificationItems = <String>[].obs;

  // Variables to hold selected dropdown values
  final selectedOwnership = Rx<String?>(null);
  final selectedOccupancyStatus = Rx<String?>(null);
  final selectedNatureOfBusiness = Rx<String?>(null);
  final selectedDrCode = Rx<String?>(null);
  final selectedPropertyType = Rx<String?>(null);
  final selectedClassification = Rx<String?>(null);

  final inputWaterBill = Rx<String?>(null);
  final inputWaterMeter = Rx<String?>(null);
  final inputCorrectAddress = Rx<String?>(null);
  final inputOccupierName = Rx<String?>(null);
  final inputOccupierPhoneNumber = Rx<String?>(null);
  final inputOccupierEmail = Rx<String?>(null);
  final inputShopName = Rx<String?>(null);
  final inputAddRemark = Rx<String?>(null);

  var isWaterBillVisible = false.obs;
  var isWaterMeterVisible = false.obs;
  var isCorrectAddressVisible = false.obs;

  final ApiService apiService = ApiService();

  @override
  void onInit() {
    fetchDropdownList();

    super.onInit();
  }

  void onClose() {
    // Dispose all controllers when the controller is disposed
    waterBillController.dispose();
    waterMeterController.dispose();
    correctAddressController.dispose();
    occupierNameController.dispose();
    occupierPhoneNumberController.dispose();
    occupierEmailController.dispose();
    shopNameController.dispose();
    super.onClose();
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
              ?.map((item) =>
                  "${item.code!} - ${item.natureOfBussinessCodeName!}")
              .toList() ??
          [];
      drCodeItems.value = result?.drCode
              ?.map((item) => "${item.code!} - ${item.drCodeName!}")
              .toList() ??
          [];

      propertyTypeItems.value = result?.propertyType
              ?.map((item) => "${item.code!} - ${item.propertyTypeName!}")
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
