import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/dashedline_painter.dart';
import 'package:v_ranger/core/common_widgets/form_loader.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/common_widgets/step_Indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/upload_survey_controller.dart';
import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';

class SurveyUploadImagePage extends StatelessWidget {
  final BatachesFileListController controller;
  final bool isEdit;
  final bool isBulkUpdate;
  final int fileIndex;

  SurveyUploadImagePage(
      {super.key,
      required this.controller,
      required this.isEdit,
      required this.isBulkUpdate,
      required this.fileIndex});

  final UploadSurveyController surveyFormController =
      Get.put(UploadSurveyController());

  @override
  Widget build(BuildContext context) {
    // ignore: unrelated_type_equality_checks
    if (isEdit && surveyFormController.isPhotoPopulated == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        surveyFormController.populatePhotosFromApi(controller, fileIndex);
      });
    }
    surveyFormController.isBulkUpdate = isBulkUpdate;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        surveyFormController.images.clear();
        surveyFormController.isPhotoPopulated.value = false;
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Text(
            "Upload Photo",
            style: PromptStyle.appBarTitleStyle,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              surveyFormController.images.clear();

              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StepIndicator(
                  number1: 1,
                  number2: 2,
                  number3: 3,
                  isActive1: true,
                  isActive2: true,
                  isActive3: true,
                ),
              ),
              Obx(() {
                return Expanded(
                    //   height: 600,
                    child: surveyFormController.isPhotoLoading.value == false
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: surveyFormController.images.length +
                                1, // Increment itemCount by 1
                            itemBuilder: (context, index) {
                              if (index == surveyFormController.images.length) {
                                // Return the "Add Item" button as the last item
                                return GestureDetector(
                                  onTap: () {
                                    // Implement the logic to add a new item to the list
                                    surveyFormController.pickImage(isEdit
                                        ? controller
                                            .data
                                            .value!
                                            .data!
                                            .completedDetails![fileIndex]
                                            .accountNo!
                                        : controller
                                            .data
                                            .value!
                                            .data!
                                            .pendingDetails![fileIndex]
                                            .accountNo!); // Replace with your actual method
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 15, 15),
                                    child: CustomPaint(
                                      foregroundPainter: DashedLinePainter(),
                                      child: Container(
                                        height: 190,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryColor
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              surveyFormController.pickImage(isEdit
                                                  ? controller
                                                      .data
                                                      .value!
                                                      .data!
                                                      .completedDetails![
                                                          fileIndex]
                                                      .accountNo!
                                                  : controller
                                                      .data
                                                      .value!
                                                      .data!
                                                      .pendingDetails![
                                                          fileIndex]
                                                      .accountNo!); // Replace with your actual method
                                            },
                                            child: Center(
                                              child: Image.asset(
                                                'assets/icons/add_Image.png',
                                                width: 40.0,
                                                height: 40.0,
                                              ),

                                              //  Icon(
                                              //   Icons.camera_alt,
                                              //   color: Colors.grey,
                                              //   size: 40,
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                final image =
                                    surveyFormController.images[index];
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 0, 15, 15),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Adjust the radius as needed
                                        child: Image.file(
                                          File(image.path),
                                          fit: BoxFit.cover,
                                          //  height: 190,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () {
                                          surveyFormController
                                              .removeImage(index);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          )
                        : const Center(child: FormLoader()));
              }),
              _buildSubmitButton(context, buttonName: 'Submit')
            ],
          ),
        ),
      ),
    );
  }

  // Display selected images in a horizontal list

  Widget customTextField({String? labelText, String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(labelText, style: PromptStyle.profileSubTitle),
          ),
        SizedBox(
          height: 50,
          child: TextField(
            textAlign: TextAlign.start,
            cursorColor: AppColors.primaryColor,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              hintText: hintText,
              hintStyle: PromptStyle.hintTextStyle,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(12.0), // Adjust the radius as needed
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 2.0), // Adjust the border color and width as needed
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                    color: AppColors.boaderColor,
                    width: 2.0), // Adjust the border color and width as needed
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context,
      {required String buttonName}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: Obx(() {
          if (!surveyFormController.isLoading.value) {
            return SingleButton(
              bgColor: AppColors.primaryColor,
              buttonName: buttonName,
              onTap: () async {
                if (!surveyFormController.isLoading.value) {
                  List<String> batchDetailIds = [];

                  // Prepare batchDetailIds based on whether it's bulkUpdate or single
                  if (isBulkUpdate) {
                    batchDetailIds = controller.selectedBatchIds
                        .map((id) => id.toString())
                        .toList();
                  } else {
                    if (isEdit == true) {
                      batchDetailIds.add(controller
                          .data.value!.data!.completedDetails![fileIndex].id
                          .toString());
                    } else {
                      batchDetailIds.add(controller
                          .data.value!.data!.pendingDetails![fileIndex].id
                          .toString());
                    }
                  }

                  // Check internet connectivity
                  var connectivityResults =
                      await Connectivity().checkConnectivity();
                  bool isOnline = connectivityResults.isNotEmpty &&
                      connectivityResults
                          .any((result) => result != ConnectivityResult.none);
                  if (isOnline) {
                    // If online, proceed to submit the survey
                    surveyFormController.postSurvey(
                      isEdit == true
                          ? controller.data.value!.data!
                              .completedDetails![fileIndex].batchId
                              .toString()
                          : controller.data.value!.data!
                              .pendingDetails![fileIndex].batchId
                              .toString(),
                      batchDetailIds, // Passing the list of batchDetailIds
                    );
                  } else {
                    // If offline, save the survey data locally
                    await surveyFormController.saveSurveyLocally(
                      isEdit == true
                          ? controller.data.value!.data!
                              .completedDetails![fileIndex].batchId
                              .toString()
                          : controller.data.value!.data!
                              .pendingDetails![fileIndex].batchId
                              .toString(),
                      batchDetailIds,
                    );

                    // Show a snackbar or dialog to notify the user
                    surveyFormController.showNormalSnackBar(
                        'No internet connection. Survey saved locally and will be uploaded once online.');
                  }
                }
              },
              isLoading: surveyFormController.isLoading.value,
            );
          } else {
            return const Center(child: FormLoader());
          }
        }),
      ),
    );
  }
}
