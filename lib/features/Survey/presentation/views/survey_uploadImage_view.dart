import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/dashedline_painter.dart';
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
  final int index;
  SurveyUploadImagePage(
      {super.key,
      required this.controller,
      required this.isEdit,
      required this.isBulkUpdate,
      required this.index});

  final UploadSurveyController surveyFormController =
      Get.put(UploadSurveyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Survey Form",
          style: PromptStyle.appBarTitleStyle,
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
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: surveyFormController.images.length +
                      1, // Increment itemCount by 1
                  itemBuilder: (context, index) {
                    if (index == surveyFormController.images.length) {
                      // Return the "Add Item" button as the last item
                      return GestureDetector(
                        onTap: () {
                          // Implement the logic to add a new item to the list
                          surveyFormController
                              .pickImage(); // Replace with your actual method
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: CustomPaint(
                            foregroundPainter: DashedLinePainter(),
                            child: Container(
                              height: 190,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: surveyFormController.pickImage,
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      final image = surveyFormController.images[index];
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  8.0), // Adjust the radius as needed
                              child: Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                                // height: 190,
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
                                surveyFormController.removeImage(index);
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              );
            }),
            _buildSubmitButton(context, buttonName: 'Submit')
          ],
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
                onTap: () {
                  if (!surveyFormController.isLoading.value) {
                    List<String> batchDetailIds = [];

                    if (isBulkUpdate) {
                      // Send selectedBatchIds if isBulkUpdate is true
                      batchDetailIds = controller.selectedBatchIds
                          .map((id) => id.toString())
                          .toList();
                    } else {
                      if (isEdit == true) {
                        batchDetailIds.add(controller
                            .data.value!.data!.completedDetails![index].id
                            .toString());
                      } else {
                        batchDetailIds.add(controller
                            .data.value!.data!.pendingDetails![index].id
                            .toString());
                      }
                    }

                    surveyFormController.postSurvey(
                      isEdit == true
                          ? controller.data.value!.data!
                              .completedDetails![index].batchId
                              .toString()
                          : controller
                              .data.value!.data!.pendingDetails![index].batchId
                              .toString(),
                      batchDetailIds, // Passing the list of batchDetailIds
                    );
                  }
                },
                isLoading: surveyFormController.isLoading.value,
              );
            } else {
              return const SizedBox(
                  child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  semanticsLabel: 'uploading',
                ),
              ));
            }
          })),
    );
  }
}
