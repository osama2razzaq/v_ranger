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

  Future<void> postSurvey(
      String batchId, String batchDetailId, String userId) async {
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate = DateFormat('dd/MM/yy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    try {
      final result = await apiService.postSurvey(
        batchId: batchId,
        batchDetailId: batchDetailId,
        userId: userId,
        waterMeterNo: waterMeterController.text,
        waterBillNo: waterBillController.text,
        isCorrectAddress: isCorrectAddressVisible.value,
        correctAddress: correctAddressController.text,
        ownership: ownershipItems.isNotEmpty ? ownershipItems.first : null,
        contactPersonName: occupierNameController.text,
        contactNumber: occupierPhoneNumberController.text,
        email: occupierEmailController.text,
        natureOfBusinessCode: natureOfBusinessItems.isNotEmpty
            ? natureOfBusinessItems.first
            : null,
        shopName: shopNameController.text,
        drCode: drCodeItems.isNotEmpty ? drCodeItems.first : null,
        propertyCode:
            propertyTypeItems.isNotEmpty ? propertyTypeItems.first : null,
        occupancy:
            occupancyStatusItems.isNotEmpty ? occupancyStatusItems.first : null,
        remark: 'your_remark',
        visitDate: formattedDate,
        visitTime: formattedTime,
        photo1: null,
        photo2: null,
        photo3: null,
        photo4: null,
        photo5: null,
      );

      print("fetchDropdownList:: ${result!.body}");
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      dropDownData.value = null; // Clear data on error
    }
  }
}
