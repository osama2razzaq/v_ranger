import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/common_widgets/step_Indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/survey_form_controller.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_uploadImage_view.dart';
import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';

class SurveyFormPage extends StatelessWidget {
  final BatachesFileListController controller;
  final bool isEdit;
  final bool isBulkUpdate;

  final int index;
  SurveyFormPage(
      {Key? key,
      required this.controller,
      required this.isEdit,
      required this.isBulkUpdate,
      required this.index})
      : super(key: key);
  final SurveyFormController surveyFormController =
      Get.put(SurveyFormController());

  @override
  Widget build(BuildContext context) {
    // Use Obx to call populateFieldsFromApi when needed
    if (isEdit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        surveyFormController.populateFieldsFromApi(controller, index);
      });
    }
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
                  onTap: () {
                    Get.to(() => SurveyUploadImagePage(
                          controller: controller,
                          index: index,
                          isEdit: isEdit,
                          isBulkUpdate: isBulkUpdate,
                        ));
                  },
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
                labelText: 'Enter Water Bill Number',
                controller: surveyFormController.waterBillController,
                // focusNode: surveyFormController.waterBillFocus,
                // nextFocusNode: surveyFormController.waterMeterFocus,
                onChanged: (value) =>
                    surveyFormController.inputWaterBill.value = value,
              ),
              toggleTextField(
                isVisible: surveyFormController.isWaterMeterVisible,
                labelText: 'Enter Water Meter Number',
                controller: surveyFormController.waterMeterController,
                // focusNode: surveyFormController.waterMeterFocus,
                // nextFocusNode: surveyFormController.correctAddressFocus,
                onChanged: (value) =>
                    surveyFormController.inputWaterMeter.value = value,
              ),
              toggleTextField(
                isVisible: surveyFormController.isCorrectAddressVisible,
                labelText: 'Enter Correct Address',
                controller: surveyFormController.correctAddressController,
                // focusNode: surveyFormController.correctAddressFocus,
                // nextFocusNode: surveyFormController.occupierNameFocus,
                onChanged: (value) =>
                    surveyFormController.inputCorrectAddress.value = value,
              ),
              Obx(
                () => customDropdown(
                    labelText: '--Select Ownership--',
                    items: surveyFormController.ownershipItems,
                    headerText: 'Ownership',
                    selectedValue: surveyFormController.selectedOwnership,
                    textEditingController:
                        surveyFormController.textEditingController,
                    context: context),
              ),
              Obx(
                () => customDropdown(
                    labelText: '--Select Occupancy Status--',
                    items: surveyFormController.occupancyStatusItems,
                    headerText: 'Occupancy Status',
                    selectedValue: surveyFormController.selectedOccupancyStatus,
                    textEditingController:
                        surveyFormController.textEditingController,
                    context: context),
              ),
              customTextField(
                labelText: 'Occupier Name',
                hintText: 'Enter Occupier Name',
                controller: surveyFormController.occupierNameController,
                // focusNode: surveyFormController.occupierNameFocus,
                // nextFocusNode: surveyFormController.occupierPhoneNumberFocus,
                onChanged: (value) =>
                    surveyFormController.inputOccupierName.value = value,
              ),
              const SizedBox(height: 10),
              customTextField(
                labelText: 'Occupier Phone Number',
                hintText: 'Enter Phone Number',
                controller: surveyFormController.occupierPhoneNumberController,
                // focusNode: surveyFormController.occupierPhoneNumberFocus,
                // nextFocusNode: surveyFormController.occupierEmailFocus,
                onChanged: (value) =>
                    surveyFormController.inputOccupierPhoneNumber.value = value,
              ),
              customTextField(
                labelText: 'Occupier Email',
                hintText: 'Enter Email Address',
                controller: surveyFormController.occupierEmailController,
                // focusNode: surveyFormController.occupierEmailFocus,
                // nextFocusNode: surveyFormController.shopNameFocus,
                onChanged: (value) =>
                    surveyFormController.inputOccupierEmail.value = value,
              ),
              customTextField(
                labelText: 'Shop Name',
                hintText: 'Enter Business Name',
                controller: surveyFormController.shopNameController,
                // focusNode: surveyFormController.shopNameFocus,
                // nextFocusNode: surveyFormController.addRemarkFocus,
                onChanged: (value) =>
                    surveyFormController.inputShopName.value = value,
              ),
              Obx(
                () => customDropdown(
                    labelText: '--Select Nature Of Business--',
                    items: surveyFormController.natureOfBusinessItems,
                    headerText: 'Nature Of Business Code',
                    selectedValue:
                        surveyFormController.selectedNatureOfBusiness,
                    textEditingController:
                        surveyFormController.textEditingController,
                    context: context),
              ),
              Obx(
                () => customDropdown(
                    labelText: '--Select DR Code--',
                    items: surveyFormController.drCodeItems,
                    headerText: 'DR Code',
                    selectedValue: surveyFormController.selectedDrCode,
                    textEditingController:
                        surveyFormController.textEditingController,
                    context: context),
              ),
              Obx(
                () => customDropdown(
                    labelText: '--Select Property List--',
                    items: surveyFormController.propertyTypeItems,
                    headerText: 'Property Type',
                    selectedValue: surveyFormController.selectedPropertyType,
                    textEditingController:
                        surveyFormController.textEditingController,
                    context: context),
              ),
              Obx(
                () => customDropdown(
                    labelText: '--Select Classification--',
                    items: surveyFormController.classificationItems,
                    headerText: 'Classification',
                    selectedValue: surveyFormController.selectedClassification,
                    textEditingController:
                        surveyFormController.textEditingController,
                    context: context),
              ),
              customTextField(
                labelText: 'Add (Remarks)',
                hintText: 'Write your remarks here...',
                controller: surveyFormController.addRemarkController,
                // focusNode: surveyFormController.addRemarkFocus,
                onChanged: (value) =>
                    surveyFormController.inputAddRemark.value = value,
                isAddRmarks: true,
              ),
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
    required Rx<String?> selectedValue,
    required TextEditingController? textEditingController,
    required BuildContext context,
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
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.boaderColor, width: 2),
                borderRadius: BorderRadius.circular(12)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                items: items!
                    .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                value: selectedValue.value,
                onChanged: (value) {
                  selectedValue.value = value;
                },

                dropdownSearchData: DropdownSearchData(
                  searchController: textEditingController,
                  searchInnerWidgetHeight: 50,
                  searchInnerWidget: Container(
                    height: 50,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        hintText: 'Search for an item...',
                        hintStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    // Convert both item value and searchValue to lowercase for case-insensitive comparison
                    return item.value
                        .toString()
                        .toLowerCase()
                        .contains(searchValue.toLowerCase());
                  },
                ),
                //This to clear the search value when you close the menu
                onMenuStateChange: (isOpen) {
                  if (!isOpen) {
                    surveyFormController.textEditingController.clear();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customTextField(
      {String? labelText,
      String? hintText,
      bool? isAddRmarks,
      required TextEditingController controller,
      Function(String)? onChanged,
      BuildContext? context}) {
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
            //    height: 50,
            child: TextField(
              // focusNode: focusNode,
              onChanged: onChanged,
              controller: controller,
              onSubmitted: (value) {
                // if (nextFocusNode != null) {
                //   focusNode.unfocus();
                //   FocusScope.of(context!).requestFocus(nextFocusNode);
                // }
              },
              maxLines: isAddRmarks == true
                  ? null
                  : 1, // Allows the TextField to grow vertically
              keyboardType: TextInputType.multiline, // Ensures t
              textAlign: TextAlign.start,
              cursorColor: AppColors.primaryColor,
              style: PromptStyle.dropDownInerText,

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
    // required FocusNode focusNode,
    // FocusNode? nextFocusNode,
    Function(String)? onChanged,
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
                hintText: labelText,
                controller: controller!,
                isAddRmarks: false,
                onChanged: onChanged,
              )
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
                  isBulkUpdate: isBulkUpdate,
                  isEdit: isEdit,
                ))
          },
        ),
      ),
    );
  }
}
