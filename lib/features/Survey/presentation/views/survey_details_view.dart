import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_ranger/core/common_widgets/map_view.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/common_widgets/step_Indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/batches/presentation/controllers/batchesList_controller.dart';
import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart';
// For HTTP requests

class SurveyPage extends StatelessWidget {
  final BatchesListController controller;
  final int index;
  SurveyPage({Key? key, required this.controller, required this.index})
      : super(key: key);

  final LocationController locationController = Get.put(LocationController());
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
          "Survey",
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
                  isActive2: false,
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: SizedBox(
                        child: Text('Details',
                            style: TextStyle(
                              fontFamily: AppStrings.fontFamilyPrompt,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            )),
                      ),
                    ),
                    _userInfoForm(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfoForm(BuildContext context) {
    final details = controller.data.value?.data!.first.pendingDetails![index];
    if (locationController.currentLocation.value == null) {
      locationController.getLocation();
    }

    double coordinateDistance(lat1, lon1, lat2, lon2) {
      const double p = 0.017453292519943295; // Pi / 180
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a)); // 12742 = 2 * EarthRadius (in kilometers)
    }

    return Obx(() => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailItem('Account ID', details!.id!.toString()),
              _detailItem('Account No', details!.accountNo!.toString()),
              _detailItem('Name', details.name.toString()),
              _detailItem('IC Number', details.icNo!.toString()),
              _detailItem('Address', details.address!),
              _detailItem(
                  'Total Outstanding', 'RM ${details.amount!.toString()}'),
              _detailItem('Latitude', details.batchfileLatitude!.toString()),
              _detailItem('Longitude', details.batchfileLongitude!.toString()),
              (locationController.currentLocation.value != null)
                  ? _detailItem(
                      'Distance',
                      "${coordinateDistance(
                        locationController.currentLocation.value!.latitude,
                        locationController.currentLocation.value!.longitude,
                        double.parse(details.batchfileLatitude!),
                        double.parse(details.batchfileLongitude!),
                      ).toStringAsFixed(2)} KM")
                  : _detailItem('Distance', 'Unknown'),
              // _detailItem('Distance',
              //     "${coordinateDistance(currentLocation.latitude, currentLocation.longitude, double.parse(details.batchfileLatitude!), double.parse(details.batchfileLongitude!)).toStringAsFixed(2)} KM"),
              _buildMapsButtons(context),
              _buildNextButton(context, buttonName: 'Next')
            ],
          ),
        ));
  }

  Widget _buildMapsButtons(BuildContext context) {
    final details = controller.data.value?.data!.first.pendingDetails![index];
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomButton(
            label: 'View In Maps',
            icon: Icons.map,
            onTap: () {
              Get.to(() => MapScreen(
                    lat: double.parse(details!.batchfileLatitude!),
                    long: double.parse(details.batchfileLongitude!),
                  ));
            },
            colors: [Colors.white, Colors.white!],
            borderColor: AppColors.primaryColor,
            textColor: Colors.blue[900]!,
          ),
          const SizedBox(width: 10),
          CustomButton(
            label: 'Direction',
            icon: Icons.directions,
            onTap: () {
              print('Direction tapped');
              navigateTo(1.3333, 0.33);
            },
            colors: [
              AppColors.gradientStartColor, // Start color
              AppColors.gradientMiddleColor,
              AppColors.gradientEndColor, // End color
            ],
            borderColor: AppColors.primaryColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, {required String buttonName}) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleButton(
          bgColor: AppColors.primaryColor,
          buttonName: buttonName,
          onTap: () => {},
        ),
      ),
    );
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          Text(
            label,
            style: PromptStyle.profileSubTitle,
          ),
          Text(
            value,
            style: PromptStyle.profileTitle,
          ),
          const Divider(),
        ],
      ),
    );
  }
}

void navigateTo(double lat, double lng) async {
  var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> colors;
  final Color? borderColor;
  final Color textColor;

  CustomButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.colors,
    this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
          ),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
