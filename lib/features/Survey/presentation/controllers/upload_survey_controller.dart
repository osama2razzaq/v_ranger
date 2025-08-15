import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/survey_form_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:image_watermark/image_watermark.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UploadSurveyController extends GetxController with SnackBarHelper {
  final ApiService apiService = ApiService();
  final SurveyFormController surveyFormController =
      Get.put(SurveyFormController());
  // final SurveyFormController surveyFormController =
  //     Get.find<SurveyFormController>();

  final ImagePicker _picker = ImagePicker();
  bool? isBulkUpdate;
  var images = <File>[].obs;
  var isLoading = false.obs;
  var isPhotoLoading = false.obs;
  var imageUrls = <String, String>{}.obs;
  final RxBool isPhotoPopulated = false.obs;
  DateTime now = DateTime.now();
  final uuid = Uuid();
  @override
  void onInit() {
    super.onInit();
    //  startNetworkMonitoring(); // Start monitoring network status
  }

  Future<void> pickImage(String? accountId) async {
    isLoading.value = true; // Show loader
    try {
      if (images.length >= 5) {
        showErrorSnackBar(
            'Limit reached, You can upload a maximum of 5 images');
        return;
      }

      final XFile? imageFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // compresses before decoding
      );

      if (imageFile != null) {
        // Step 1: Copy image to temp folder immediately to free camera buffer
        final tempDir = await getTemporaryDirectory();
        final copiedPath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final copiedFile = await File(imageFile.path).copy(copiedPath);

        // Step 2: Process image in background (watermark, compress)
        await _processImageWithWatermark(copiedFile, accountId);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _processImageWithWatermark(File file, String? accountId) async {
    // Load the image as bytes
    Uint8List imageBytes = await file.readAsBytes();

    // Decode the image
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) return;

    // Get timestamp
    String timestamp = DateFormat('dd/MM/yy HH:mm a').format(DateTime.now());

    // Watermark background line
    int paddingFromBottom = 50;
    int rectHeight = 100;
    int rectY1 = originalImage.height - rectHeight - paddingFromBottom;

    final assetFont = await rootBundle.load('assets/fonts/Prompt-Bold.ttf.zip');
    final font = assetFont.buffer
        .asUint8List(assetFont.offsetInBytes, assetFont.lengthInBytes);
    final bitMapFont = ImageFont.readOtherFontZip(font);

    int lineY = originalImage.height - paddingFromBottom;
    img.drawLine(
      originalImage,
      x1: 0,
      y1: lineY,
      x2: originalImage.width,
      y2: lineY,
      thickness: 130,
      color: img.ColorFloat16.rgb(0, 0, 0),
    );

    // Draw timestamp (left)
    int textHeight = 20;
    int timestampX = 20;
    int textY = rectY1 + (rectHeight - textHeight) ~/ 2 + textHeight;
    img.drawString(
        originalImage, font: bitMapFont, x: timestampX, y: textY, timestamp);

    // Draw accountId (right)
    if (isBulkUpdate != true && accountId != null) {
      int accountIdWidth = accountId.length * 20;
      int accountIdX = originalImage.width - accountIdWidth - 100;
      img.drawString(
          originalImage, font: bitMapFont, x: accountIdX, y: textY, accountId);
    }

    // Compress under 2MB
    int quality = 85;
    Uint8List compressedImageBytes =
        Uint8List.fromList(img.encodeJpg(originalImage, quality: quality));

    while (compressedImageBytes.length > 1024 * 1024) {
      compressedImageBytes = await FlutterImageCompress.compressWithList(
        compressedImageBytes,
        quality: 85,
        minWidth: 600,
        minHeight: 400,
      );
    }

    // Save compressed image
    final compressedImagePath = '${file.path}_compressed.jpg';
    final compressedImageFile = File(compressedImagePath);
    await compressedImageFile.writeAsBytes(compressedImageBytes);

    print(
        'Compressed Image Size: ${compressedImageBytes.lengthInBytes / 1024} KB');

    // Add to list
    images.add(compressedImageFile);
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

  Future<File> saveWithUniqueName(File file) async {
    final dir = await getTemporaryDirectory(); // or app-specific directory
    final uniqueName = '${uuid.v4()}.jpg'; // random unique file name
    final newPath = '${dir.path}/$uniqueName';
    return file.copy(newPath);
  }

  Future<void> convertUrlToFile(String? photo1, String? photo2, String? photo3,
      String? photo4, String? photo5) async {
    List<String?> photos = [photo1, photo2, photo3, photo4, photo5];
    isPhotoLoading.value = true;

    for (String? photo in photos) {
      if (photo != null && photo.isNotEmpty) {
        try {
          File imageFile = await urlToFile(photo);

          // Save with a unique name to prevent cache duplicates
          File uniqueFile = await saveWithUniqueName(imageFile);

          // Prevent duplicates in memory
          bool alreadyExists = images.any((f) => f.path == uniqueFile.path);
          if (!alreadyExists) {
            images.add(uniqueFile);
          }
        } catch (e) {
          print("Error loading photo: $e");
        }
      }
    }
    isPhotoLoading.value = false;
  }

  void populatePhotosFromApi(controller, int index) {
    // if (!isPhotoPopulated.value) {
    images.clear();
    final surveyDetail =
        controller.data.value!.data!.completedDetails![index].survey!;

    convertUrlToFile(surveyDetail.photo1, surveyDetail.photo2,
        surveyDetail.photo3, surveyDetail.photo4, surveyDetail.photo5);
    // Exit the loop once the first non-null photo is found and processed

    isPhotoPopulated.value = true;
    // }
  }

  void onClose() {
    super.onClose();
  }

  Future<void> postSurvey(
    String batchId,
    List<String> batchDetailIds,
  ) async {
    // Format the date and time
    String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
    String formattedTime = DateFormat('HH:mm').format(DateTime.now());
    print("osama!! $formattedDate $formattedTime ");

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
        print("response.statusCode== ${response?.statusCode}");
        if (response?.statusCode == 201) {
          showNormalSnackBar('Survey submitted successfully');
          images.clear();
          isPhotoPopulated.value = false;
          surveyFormController.clearForm(); // Clear form data
          Get.offAllNamed(Routes.dashboard);
        }
      } catch (e) {
        showErrorSnackBar('Failed to load data: $e');
      } finally {
        isLoading.value = false; // End loading
      }
    }
  }

  Future<void> saveSurveyLocally(
      String batchId, List<String> batchDetailIds) async {
    String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
    String formattedTime = DateFormat('HH:mm').format(DateTime.now());
    List<String> imagePaths = images.map((file) => file.path).toList();

    // Create a survey map

    Map<String, dynamic> surveyData = {
      'batchId': batchId,
      'batchDetailIds': batchDetailIds,
      'hasWaterMeter': surveyFormController.isWaterMeterVisible.value,
      'waterMeterNo': surveyFormController.inputWaterMeter.value,
      'hasWaterBill': surveyFormController.isWaterBillVisible.value,
      'waterBillNo': surveyFormController.inputWaterBill.value,
      'isCorrectAddress': surveyFormController.isCorrectAddressVisible.value,
      'correctAddress': surveyFormController.inputCorrectAddress.value,
      'ownership': surveyFormController.selectedOwnership.value,
      'contactPersonName': surveyFormController.inputOccupierName.value,
      'contactNumber': surveyFormController.inputOccupierPhoneNumber.value,
      'email': surveyFormController.inputOccupierEmail.value,
      'natureOfBusinessCode':
          surveyFormController.selectedNatureOfBusiness.value,
      'shopName': surveyFormController.inputShopName.value,
      'drCode': surveyFormController.selectedDrCode.value,
      'propertyCode': surveyFormController.selectedPropertyType.value,
      'occupancy': surveyFormController.selectedOccupancyStatus.value,
      'classification': surveyFormController.selectedClassification.value,
      'remark': surveyFormController.inputAddRemark.value,
      'visitDate': formattedDate,
      'visitTime': formattedTime,
      'imagePaths': imagePaths, // Add the image paths here
      // Images can be added if needed
    };

    // Fetch locally stored surveys
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedSurveys = prefs.getStringList('pending_surveys') ?? [];

    // Add the new survey to the list
    savedSurveys.add(jsonEncode(surveyData));

    // Save updated survey list
    await prefs.setStringList('pending_surveys', savedSurveys);
    images.clear();
    surveyFormController.clearForm();
    Get.offAllNamed(Routes.dashboard);
    print('Survey saved locally.');
  }

  Future<void> postPendingSurveys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedSurveys = prefs.getStringList('pending_surveys') ?? [];

    if (savedSurveys.isNotEmpty) {
      List<String> surveysToRemove =
          []; // List to collect successfully posted surveys

      for (String survey in savedSurveys) {
        // Convert the JSON-encoded string back to a Map
        Map<String, dynamic> surveyData = jsonDecode(survey);

        // Extract necessary fields for posting
        String batchId = surveyData['batchId'];
        List<String> batchDetailIds =
            List<String>.from(surveyData['batchDetailIds']);

        // Extract image paths (handle case where it's not a list)
        List<String> imagePaths = [];
        if (surveyData['imagePaths'] is List) {
          imagePaths = List<String>.from(surveyData['imagePaths']);
        } else if (surveyData['imagePaths'] is String) {
          imagePaths = [surveyData['imagePaths']];
        }

        // Reconstruct File objects from the image paths
        File? photo1 = imagePaths.isNotEmpty ? File(imagePaths[0]) : null;
        File? photo2 = imagePaths.length > 1 ? File(imagePaths[1]) : null;
        File? photo3 = imagePaths.length > 2 ? File(imagePaths[2]) : null;
        File? photo4 = imagePaths.length > 3 ? File(imagePaths[3]) : null;
        File? photo5 = imagePaths.length > 4 ? File(imagePaths[4]) : null;

        // Post the survey to the server using your `postSurvey` method
        final response = await apiService.postSurvey(
          batchId: batchId,
          batchDetailIds: batchDetailIds,
          hasWaterMeter: surveyData['hasWaterMeter'],
          waterMeterNo: surveyData['waterMeterNo'],
          hasWaterBill: surveyData['hasWaterBill'],
          waterBillNo: surveyData['waterBillNo'],
          isCorrectAddress: surveyData['isCorrectAddress'],
          correctAddress: surveyData['correctAddress'],
          ownership: surveyData['ownership'],
          contactPersonName: surveyData['contactPersonName'],
          contactNumber: surveyData['contactNumber'],
          email: surveyData['email'],
          natureOfBusinessCode: surveyData['natureOfBusinessCode'],
          shopName: surveyData['shopName'],
          drCode: surveyData['drCode'],
          propertyCode: surveyData['propertyCode'],
          occupancy: surveyData['occupancy'],
          classification: surveyData['classification'],
          remark: surveyData['remark'],
          visitDate: surveyData['visitDate'],
          visitTime: surveyData['visitTime'],
          photo1: photo1,
          photo2: photo2,
          photo3: photo3,
          photo4: photo4,
          photo5: photo5,
        );

        // If successfully posted, collect the survey to be removed later
        if (response != null && response.statusCode == 201) {
          print('Survey with images successfully posted.');
          surveysToRemove.add(survey);
        } else {
          print('Failed to post survey. Keeping it in local storage.');
        }
      }

      // Remove the successfully posted surveys from the list after iteration
      savedSurveys.removeWhere((survey) => surveysToRemove.contains(survey));

      // Save the updated list to SharedPreferences
      await prefs.setStringList('pending_surveys', savedSurveys);
    } else {
      // showErrorSnackBar('No pending surveys to post.');
    }
  }
}
