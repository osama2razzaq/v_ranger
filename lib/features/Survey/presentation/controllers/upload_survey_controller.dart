import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/survey_form_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:image_watermark/image_watermark.dart';
import 'package:path_provider/path_provider.dart';

class UploadSurveyController extends GetxController with SnackBarHelper {
  final ApiService apiService = ApiService();
  final SurveyFormController surveyFormController =
      Get.find<SurveyFormController>();

  final ImagePicker _picker = ImagePicker();
  var images = <File>[].obs;
  var isLoading = false.obs;
  var isPhotoLoading = false.obs;
  var imageUrls = <String, String>{}.obs;
  final RxBool isPhotoPopulated = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickImage(String? accountId) async {
    isLoading.value = true; // Show loader
    try {
      if (images.length < 5) {
        final XFile? imageFile =
            await _picker.pickImage(source: ImageSource.camera);

        if (imageFile != null) {
          // Load the image as bytes
          Uint8List imageBytes = await imageFile.readAsBytes();

          // Decode the image to get its dimensions
          img.Image? originalImage = img.decodeImage(imageBytes);

          if (originalImage != null) {
            // Get the current timestamp
            String timestamp =
                DateFormat('dd/MM/yy HH:mm a').format(DateTime.now());

            // Set rectangle and text position
            int paddingFromBottom = 50; // Padding from the bottom
            int rectHeight = 100; // Height of the rectangle box

            int rectY1 = originalImage.height - rectHeight - paddingFromBottom;

            final assetFont =
                await rootBundle.load('assets/fonts/Prompt-Bold.ttf.zip');
            final font = assetFont.buffer
                .asUint8List(assetFont.offsetInBytes, assetFont.lengthInBytes);
            final bitMapFont = ImageFont.readOtherFontZip(font);

            int lineY = originalImage.height - paddingFromBottom;
            img.drawLine(originalImage,
                x1: 0,
                y1: lineY,
                x2: originalImage.width,
                y2: lineY,
                thickness: 130,
                color: img.ColorFloat16.rgb(0, 0, 0));

            // Calculate the positions for the timestamp (left) and accountId (right)
            int textHeight = 20; // Approximate height based on font size
            int timestampX = 20; // 20 pixels from the left edge
            int textY = rectY1 +
                (rectHeight - textHeight) ~/ 2 +
                textHeight; // Centered vertically

            // Position for accountId on the right
            int accountIdWidth = accountId != null ? accountId.length * 20 : 0;
            int accountIdX = originalImage.width -
                accountIdWidth -
                100; // 20 pixels from the right edge

            // Draw the timestamp text on the left (white text)
            img.drawString(
              originalImage,
              font: bitMapFont,
              x: timestampX,
              y: textY,
              timestamp,
            );

            // Draw the accountId text on the right (white text)
            if (accountId != null) {
              img.drawString(
                originalImage,
                font: bitMapFont,
                x: accountIdX,
                y: textY,
                accountId,
              );
            }

            // Convert the image back to bytes
            Uint8List modifiedImageBytes =
                Uint8List.fromList(img.encodeJpg(originalImage));

            // Save the modified image back to a file
            final String modifiedImagePath = '${imageFile.path}_modified.jpg';
            final File modifiedImageFile = File(modifiedImagePath);
            await modifiedImageFile.writeAsBytes(modifiedImageBytes);

            // Add the modified image to the list
            images.add(modifiedImageFile);
          }
        }
      } else {
        // Limit reached, show a message
        showErrorSnackBar(
            'Limit reached, You can upload a maximum of 5 images');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  Future<File> urlToFile(String imageUrl) async {
    final dio = Dio();
    try {
      // Get the temporary directory of the device
      var tempDir = await getTemporaryDirectory();

      // Create a file path in the temporary directory
      String filePath = '${tempDir.path}/${imageUrl.split('/').last}';

      // Download the file from the URL

      await dio.download(imageUrl, filePath);

      // Return the File
      return File(filePath);
    } catch (e) {
      throw Exception("Error downloading file: $e");
    }
  }

  Future<void> convertUrlToFile(String? photo1, String? photo2, String? photo3,
      String? photo4, String? photo5) async {
    List<String?> photos = [photo1, photo2, photo3, photo4, photo5];
    isPhotoLoading.value = true;
    for (String? photo in photos) {
      if (photo != null && photo.isNotEmpty) {
        File imageFile = await urlToFile(photo);
        images.add(imageFile); // Adding to your observable list
        isPhotoLoading.value = false;
      }
    }
  }

  void populatePhotosFromApi(controller, int index) {
    if (!isPhotoPopulated.value) {
      final surveyDetail =
          controller.data.value!.data!.completedDetails![index].survey!;

      convertUrlToFile(surveyDetail.photo1, surveyDetail.photo2,
          surveyDetail.photo3, surveyDetail.photo4, surveyDetail.photo5);
      // Exit the loop once the first non-null photo is found and processed

      isPhotoPopulated.value = true;
    }
  }

  void onClose() {
    super.onClose();
  }

  Future<void> postSurvey(
    String batchId,
    List<String> batchDetailIds,
  ) async {
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate = DateFormat('dd/MM/yy').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    print("batchDetailIdslisr $batchDetailIds");
    if (images.isEmpty) {
      showErrorSnackBar('You must upload at least 1 image');
    } else {
      try {
        isLoading.value = true; //
        final response = await apiService.postSurvey(
          batchId: batchId,
          batchDetailIds: batchDetailIds,
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
          classification: surveyFormController.classificationItems.isNotEmpty
              ? surveyFormController.selectedClassification.value
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
}
