import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:get/get.dart';
import 'package:gmaps_by_road_distance_calculator/gmaps_by_road_distance_calculator.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:v_ranger/core/common_widgets/map_view.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/common_widgets/step_Indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_form_view.dart';
import 'package:v_ranger/features/batches/presentation/controllers/bataches_file_list_Controller.dart';

import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart';

class SurveyDetailsPage extends StatelessWidget {
  final BatachesFileListController controller;
  final bool isEdit;
  final bool isBulkUpdate;
  final int index;

  SurveyDetailsPage(
      {Key? key,
      required this.controller,
      required this.isEdit,
      required this.isBulkUpdate,
      required this.index})
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
                  onTap: () {
                    Get.to(() => SurveyFormPage(
                          controller: controller,
                          isBulkUpdate: isBulkUpdate,
                          index: index,
                          isEdit: isEdit,
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
              ),
              _buildNextButton(context, buttonName: 'Next')
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfoForm(BuildContext context) {
    var completedDetails =
        (controller.data.value?.data?.completedDetails != null &&
                index < controller.data.value!.data!.completedDetails!.length)
            ? controller.data.value!.data!.completedDetails![index]
            : null;

// Safely access pendingDetails
    var pendingDetails = (controller.data.value?.data?.pendingDetails != null &&
            index < controller.data.value!.data!.pendingDetails!.length)
        ? controller.data.value!.data!.pendingDetails![index]
        : null;

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

    Future<double> getDistance(String address) async {
      List<Location> locations = await locationFromAddress(address);
      if (locationController.currentLocation.value != null &&
          locations.isNotEmpty) {
        ByRoadDistanceCalculator distanceCalculator =
            ByRoadDistanceCalculator();
        String distanceString = await distanceCalculator.getDistance(
            'AIzaSyBfk2lf9GDygZA8S95qs4Q94pRYrEjls8M',
            startLatitude: // Your API key
                locationController.currentLocation.value!.latitude!,
            startLongitude:
                locationController.currentLocation.value!.longitude!,
            destinationLatitude: locations.first.latitude,
            destinationLongitude: locations.first.longitude,
            travelMode:
                TravelModes.driving // Assuming travelMode should be a String
            );

        // Convert the distance to double
        double distance = double.tryParse(distanceString) ?? -1;
        return distance;
      }
      return -1;
    }

    return Obx(() => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _detailItem(
                  'Account ID',
                  !isEdit
                      ? pendingDetails?.id?.toString() ?? 'N/A'
                      : completedDetails?.id?.toString() ?? 'N/A'),
              _detailItem(
                  'Account No',
                  !isEdit
                      ? pendingDetails?.accountNo?.toString() ?? 'N/A'
                      : completedDetails?.accountNo?.toString() ?? 'N/A'),
              _detailItem(
                  'Name',
                  !isEdit
                      ? pendingDetails?.name?.toString() ?? 'N/A'
                      : completedDetails?.name?.toString() ?? 'N/A'),
              _detailItem(
                  'IC Number',
                  !isEdit
                      ? pendingDetails?.icNo?.toString() ?? 'N/A'
                      : completedDetails?.icNo?.toString() ?? 'N/A'),
              _detailItem(
                  'Address',
                  !isEdit
                      ? pendingDetails?.address ?? 'N/A'
                      : completedDetails?.address ?? 'N/A'),
              _detailItem(
                  'Total Outstanding',
                  !isEdit
                      ? 'RM ${pendingDetails?.amount?.toString() ?? '0.00'}'
                      : 'RM ${completedDetails?.amount?.toString() ?? '0.00'}'),
              _detailItem(
                  'Latitude',
                  !isEdit
                      ? pendingDetails?.batchfileLatitude?.toString() ?? 'N/A'
                      : completedDetails?.batchfileLatitude?.toString() ??
                          'N/A'),
              _detailItem(
                  'Longitude',
                  !isEdit
                      ? pendingDetails?.batchfileLongitude?.toString() ?? 'N/A'
                      : completedDetails?.batchfileLongitude?.toString() ??
                          'N/A'),
              FutureBuilder<double>(
                future: getDistance(
                    "${(!isEdit ? pendingDetails?.address : completedDetails?.address) ?? ''},${(!isEdit ? pendingDetails?.tamanMmid : completedDetails?.tamanMmid) ?? ''}"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _detailItem('Distance', 'Calculating...');
                  } else if (snapshot.hasError) {
                    return _detailItem(
                        'Distance', 'Error calculating distance');
                  } else if (snapshot.hasData) {
                    return _detailItem(
                        'Distance', "${snapshot.data!.toStringAsFixed(2)} KM");
                  } else {
                    return _detailItem('Distance', 'Unknown');
                  }
                },
              ),
              _buildMapsButtons(context),
            ],
          ),
        ));
  }

  Widget _buildMapsButtons(BuildContext context) {
    var completedDetails =
        (controller.data.value?.data?.completedDetails != null &&
                index < controller.data.value!.data!.completedDetails!.length)
            ? controller.data.value!.data!.completedDetails![index]
            : null;

// Safely access pendingDetails
    var pendingDetails = (controller.data.value?.data?.pendingDetails != null &&
            index < controller.data.value!.data!.pendingDetails!.length)
        ? controller.data.value!.data!.pendingDetails![index]
        : null;

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
                    destinationAddress:
                        "${isEdit ? pendingDetails!.address! : completedDetails!.address!},${isEdit ? pendingDetails!.tamanMmid : completedDetails!.tamanMmid}",
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
              navigateTo(
                  !isEdit
                      ? double.parse(pendingDetails!.batchfileLatitude!)
                      : double.parse(completedDetails!.batchfileLatitude!),
                  !isEdit
                      ? double.parse(pendingDetails!.batchfileLongitude!)
                      : double.parse(completedDetails!.batchfileLongitude!),
                  context);
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
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        width: MediaQuery.of(context).size.width,
        child: SingleButton(
          bgColor: AppColors.primaryColor,
          buttonName: buttonName,
          onTap: () => {
            Get.to(() => SurveyFormPage(
                  controller: controller,
                  index: index,
                  isEdit: isEdit,
                  isBulkUpdate: isBulkUpdate,
                ))
          },
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

void navigateTo(double lat, double lng, BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Choose Navigation App",
            style: TextStyle(
              fontFamily: AppStrings.fontFamilyPrompt,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              fontSize: 18,
            )),
        content: const Text("Which app would you like to use for navigation?",
            style: TextStyle(
              fontFamily: AppStrings.fontFamilyPrompt,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              fontSize: 12,
            )),
        actions: [
          ListTile(
            leading: Image.asset(
              'assets/icons/google_maps_icon.png',
              width: 40.0,
              height: 40.0,
            ),
            title: const Text("Google Maps"),
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog
              launchGoogleMaps(lat, lng);
            },
          ),
          ListTile(
            leading: Image.asset(
              'assets/icons/waze_icon.png',
              width: 40.0,
              height: 40.0,
            ),
            title: const Text("Waze"),
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog
              launchWazeRoute(lat, lng);
            },
          ),
        ],
      );
    },
  );
}

Future<void> launchWazeRoute(double lat, double lng) async {
  var url = 'waze://?ll=${lat.toString()},${lng.toString()}';
  var fallbackUrl =
      'https://waze.com/ul?ll=${lat.toString()},${lng.toString()}&navigate=yes';
  try {
    bool launched = false;
    if (!kIsWeb) {
      launched = await url_launcher.launchUrl(Uri.parse(url));
    }
    if (!launched) {
      await url_launcher.launchUrl(Uri.parse(fallbackUrl));
    }
  } catch (e) {
    await url_launcher.launchUrl(Uri.parse(fallbackUrl));
  }
}

Future<void> launchGoogleMaps(double lat, double lng) async {
  var url = 'google.navigation:q=${lat.toString()},${lng.toString()}';
  var fallbackUrl =
      'https://www.google.com/maps/search/?api=1&query=${lat.toString()},${lng.toString()}';
  try {
    bool launched = false;
    if (!kIsWeb) {
      launched = await url_launcher.launchUrl(Uri.parse(url));
    }
    if (!launched) {
      await url_launcher.launchUrl(Uri.parse(fallbackUrl));
    }
  } catch (e) {
    await url_launcher.launchUrl(Uri.parse(fallbackUrl));
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> colors;
  final Color? borderColor;
  final Color textColor;

  const CustomButton({
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
