import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/survey_form_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class UploadSurveyController extends GetxController with SnackBarHelper {
  final ApiService apiService = ApiService();
  final SurveyFormController surveyFormController =
      Get.find<SurveyFormController>();
  final ImagePicker _picker = ImagePicker();
  var images = <XFile>[].obs;
  var isLoading = false.obs;
  Future<void> pickImage() async {
    if (images.length < 5) {
      final XFile? imageFile =
          await _picker.pickImage(source: ImageSource.camera);
      if (imageFile != null) {
        // Load the image using the image package
        Uint8List imageBytes = await imageFile.readAsBytes();
        img.Image? originalImage = img.decodeImage(imageBytes);

        // Check if image is loaded
        if (originalImage != null) {
          // Get the current time
          String timestamp =
              DateFormat('dd/MM/yy HH:mm').format(DateTime.now());

          // Define position and color
          int xPosition = 10;
          int yPosition = originalImage.height - 30;
          int color = img.getColor(232, 232, 222); // White color
          img.BitmapFont font = img.arial_24;

          // Draw the timestamp on the image
          img.drawString(
            originalImage,
            font,
            xPosition,
            yPosition,
            timestamp,
            color: color,
          );

          // Save the modified image back to a file
          Uint8List modifiedImageBytes =
              Uint8List.fromList(img.encodeJpg(originalImage));
          final String modifiedImagePath =
              '${imageFile.path}_modified.jpg'; // New file path
          final File modifiedImageFile = File(modifiedImagePath);
          await modifiedImageFile.writeAsBytes(modifiedImageBytes);

          // Add the modified image to the list
          images.add(XFile(modifiedImagePath));
        }
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
      final response = await apiService.postSurvey(
        batchId: batchId,
        batchDetailId: batchDetailId,
        hasWaterMeter: surveyFormController.isWaterMeterVisible.value,
        waterMeterNo: surveyFormController.inputWaterMeter.value,
        hasWaterBill: surveyFormController.isWaterBillVisible.value,
        waterBillNo: surveyFormController.inputWaterBill.value,
        isCorrectAddress: surveyFormController.isCorrectAddressVisible.value,
        correctAddress: surveyFormController.inputCorrectAddress.value,
        ownership: surveyFormController.ownershipItems.isNotEmpty
            ? surveyFormController.selectedOwnership.value
            : null,
        contactPersonName: surveyFormController.inputOccupierName.value,
        contactNumber: surveyFormController.inputOccupierPhoneNumber.value,
        email: surveyFormController.inputOccupierEmail.value,
        natureOfBusinessCode:
            surveyFormController.natureOfBusinessItems.isNotEmpty
                ? surveyFormController.selectedNatureOfBusiness.value
                : null,
        shopName: surveyFormController.inputShopName.value,
        drCode: surveyFormController.drCodeItems.isNotEmpty
            ? surveyFormController.selectedDrCode.value
            : null,
        propertyCode: surveyFormController.propertyTypeItems.isNotEmpty
            ? surveyFormController.selectedPropertyType.value
            : null,
        occupancy: surveyFormController.occupancyStatusItems.isNotEmpty
            ? surveyFormController.selectedOccupancyStatus.value
            : null,
        remark: surveyFormController.inputAddRemark.value,
        visitDate: formattedDate,
        visitTime: formattedTime,
        photo1: images.length > 0 ? images[0] : null,
        photo2: images.length > 1 ? images[1] : null,
        photo3: images.length > 2 ? images[2] : null,
        photo4: images.length > 3 ? images[3] : null,
        photo5: images.length > 4 ? images[4] : null,
      );
      print("esponse.statusCode== ${response?.statusCode}");
      if (response?.statusCode == 201) {
        showNormalSnackBar('Survey submitted successfully');

        Get.offAllNamed(Routes.dashboard);
      }
    } catch (e) {
      showErrorSnackBar('Failed to load data: $e');
    } finally {
      isLoading.value = false; // End loading
    }
  }
}
