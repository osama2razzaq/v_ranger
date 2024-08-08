import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/common_widgets/step_Indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/survey_form_controller.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_uploadImage_view.dart';
import 'package:v_ranger/features/batches/presentation/controllers/batchesList_controller.dart';

class SurveyFormPage extends StatelessWidget {
  final BatchesListController controller;
  final int index;
  SurveyFormPage({Key? key, required this.controller, required this.index})
      : super(key: key);
  final SurveyFormController surveyFormController =
      Get.put(SurveyFormController());

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
        child: SingleChildScrollView(
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
                  isActive3: false,
                ),
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: surveyForm(context),
                  )),
              _buildNextButton(context, buttonName: 'Next')
            ],
          ),
        ),
      ),
    );
  }

  Widget surveyForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              toggleTextField(
                  isVisible: surveyFormController.isWaterBillVisible,
                  labelText: 'Water Bill',
                  controller: surveyFormController.waterBillController),
              toggleTextField(
                  isVisible: surveyFormController.isWaterMeterVisible,
                  labelText: 'Water Meter',
                  controller: surveyFormController.waterMeterController),
              toggleTextField(
                  isVisible: surveyFormController.isCorrectAddressVisible,
                  labelText: 'Correct Address',
                  controller: surveyFormController.correctAddressController),
              Obx(
                () => customDropdown(
                  labelText: '--Select Ownership--',
                  items: surveyFormController.ownershipItems,
                  headerText: 'Ownership',
                ),
              ),
              Obx(
                () => customDropdown(
                  labelText: '--Select Occupancy Status--',
                  items: surveyFormController.occupancyStatusItems,
                  headerText: 'Occupancy Status',
                ),
              ),
              customTextField(
                  labelText: 'Occupier Name',
                  hintText: 'Enter Occupier Name',
                  controller: surveyFormController.occupierNameController),
              const SizedBox(height: 10),
              customTextField(
                  labelText: 'Occupier Phone Number',
                  hintText: 'Enter Phone Number',
                  controller:
                      surveyFormController.occupierPhoneNumberController),
              customTextField(
                  labelText: 'Occupier Email',
                  hintText: 'Enter Email Address',
                  controller: surveyFormController.occupierEmailController),
              customTextField(
                  labelText: 'Shope Name',
                  hintText: 'Enter Business Name',
                  controller: surveyFormController.shopNameController),
              Obx(
                () => customDropdown(
                  labelText: '--Select Nature Of Business--',
                  items: surveyFormController.natureOfBusinessItems,
                  headerText: 'Nature Of Business Code',
                ),
              ),
              Obx(
                () => customDropdown(
                  labelText: '--Select DR Code--',
                  items: surveyFormController.drCodeItems,
                  headerText: 'DR Code',
                ),
              ),
              Obx(
                () => customDropdown(
                  labelText: '--Select Property List--',
                  items: surveyFormController.propertyTypeItems,
                  headerText: 'Property Type',
                ),
              ),
              Obx(() => customDropdown(
                    labelText: '--Select Classification--',
                    items: surveyFormController.classificationItems,
                    headerText: 'Classification',
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget customDropdown({
    required String? headerText,
    required String? labelText,
    required List<String>? items,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (headerText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                headerText,
                style: PromptStyle.profileSubTitle,
              ),
            ),
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(15, 0, 0, 10),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.boaderColor, width: 2),
                borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              decoration: const InputDecoration(border: InputBorder.none),
              hint: Text(
                labelText!,
                style: PromptStyle.hintTextStyle,
              ),
              items: items?.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    maxLines: 2,
                    value,
                    style: PromptStyle.dropDownInerText,
                  ),
                );
              }).toList(),
              onChanged: (newValue) {},
              isExpanded: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget customTextField({
    String? labelText,
    String? hintText,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
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
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                hintText: hintText,
                hintStyle: PromptStyle.hintTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width:
                          2.0), // Adjust the border color and width as needed
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                      color: AppColors.boaderColor,
                      width:
                          2.0), // Adjust the border color and width as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget toggleTextField({
    required RxBool? isVisible,
    required String? labelText,
    required TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              labelText!,
              style: PromptStyle.profileSubTitle,
            ),
            Obx(() => Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    activeColor: AppColors.colorWhite,
                    activeTrackColor: AppColors.gradientEndColor, //
                    inactiveTrackColor: AppColors.red,
                    inactiveThumbColor: AppColors.colorWhite,
                    trackColor: (isVisible!.value)
                        ? const WidgetStatePropertyAll(
                            AppColors.gradientEndColor)
                        : const WidgetStatePropertyAll(AppColors.red400),
                    value: isVisible!.value,

                    onChanged: (value) {
                      isVisible.value = value;
                    },
                  ),
                )),
          ],
        ),
        Obx(() => isVisible!.value
            ? customTextField(
                labelText: null,
                hintText: 'Enter $labelText',
                controller: controller!)
            : Container()),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context, {required String buttonName}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: SingleButton(
          bgColor: AppColors.primaryColor,
          buttonName: buttonName,
          onTap: () => {
            Get.to(() => SurveyUploadImagePage(
                  controller: controller,
                  index: index,
                ))
          },
        ),
      ),
    );
  }
}
