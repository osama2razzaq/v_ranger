import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/survey_form_controller.dart';
import 'package:image_picker/image_picker.dart';

class UploadSurveyController extends GetxController with SnackBarHelper {
  final ApiService apiService = ApiService();
  final SurveyFormController surveyFormController =
      Get.find<SurveyFormController>();
  final ImagePicker _picker = ImagePicker();
  var images = <XFile>[].obs;
  var isLoading = false.obs;
  Future<void> pickImage() async {
    if (images.length < 5) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        images.add(image);
      }
    } else {
      // Limit reached, show a message
      showErrorSnackBar('Limit reached, You can upload a maximum of 5 images');
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
  }

  void onClose() {
    super.onClose();
  }

  Future<void> postSurvey(
    String batchId,
    String batchDetailId,
  ) async {
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate = DateFormat('dd/MM/yy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    try {
      isLoading.value = true; //
      final result = await apiService.postSurvey(
        batchId: batchId,
        batchDetailId: batchDetailId,
        waterMeterNo: surveyFormController.waterMeterController.text,
        waterBillNo: surveyFormController.waterBillController.text,
        isCorrectAddress: surveyFormController.isCorrectAddressVisible.value,
        correctAddress: surveyFormController.correctAddressController.text,
        ownership: surveyFormController.ownershipItems.isNotEmpty
            ? surveyFormController.selectedOwnership.value
            : null,
        contactPersonName: surveyFormController.occupierNameController.text,
        contactNumber: surveyFormController.occupierPhoneNumberController.text,
        email: surveyFormController.occupierEmailController.text,
        natureOfBusinessCode:
            surveyFormController.natureOfBusinessItems.isNotEmpty
                ? surveyFormController.selectedNatureOfBusiness.value
                : null,
        shopName: surveyFormController.shopNameController.text,
        drCode: surveyFormController.drCodeItems.isNotEmpty
            ? surveyFormController.selectedDrCode.value
            : null,
        propertyCode: surveyFormController.propertyTypeItems.isNotEmpty
            ? surveyFormController.selectedPropertyType.value
            : null,
        occupancy: surveyFormController.occupancyStatusItems.isNotEmpty
            ? surveyFormController.selectedOccupancyStatus.value
            : null,
        remark: surveyFormController.addRemarkController.text,
        visitDate: formattedDate,
        visitTime: formattedTime,
        photo1: images.length > 0 ? images[0] : null,
        photo2: images.length > 1 ? images[1] : null,
        photo3: images.length > 2 ? images[2] : null,
        photo4: images.length > 3 ? images[3] : null,
        photo5: images.length > 4 ? images[4] : null,
      );
    } catch (e) {
      showErrorSnackBar('Failed to load data: $e');
      print("fetchDropdownList:: ${e}");
    } finally {
      isLoading.value = false; // End loading
    }
  }
}
