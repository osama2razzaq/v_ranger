// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// class PermissionController extends GetxController {
//   var isLocationPermissionGranted = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     checkLocationPermission();
//   }

//   Future<void> checkLocationPermission() async {
//     var status = await Permission.location.status;
//     if (status.isGranted) {
//       isLocationPermissionGranted.value = true;
//     } else {
//       requestLocationPermission();
//     }
//   }

//   Future<void> requestLocationPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       isLocationPermissionGranted.value = true;
//     } else if (status.isDenied) {
//       _showPermissionDeniedDialog();
//     } else if (status.isPermanentlyDenied) {
//       _showPermissionPermanentlyDeniedDialog();
//     }
//   }

//   void _showPermissionDeniedDialog() {
//     Get.defaultDialog(
//       title: "Permission Denied",
//       middleText:
//           "'Location Permission Required This app requires location access to function properly, even when the app is not in use. This helps us track field visits and provide accurate data updates. Your location data will only be used for this purpose and will not be shared with third parties.',",
//       onConfirm: () => requestLocationPermission(),
//       textConfirm: "Retry",
//       onCancel: () => Get.back(),
//       textCancel: "Cancel",
//     );
//   }

//   void _showPermissionPermanentlyDeniedDialog() {
//     Get.defaultDialog(
//       title: "Permission Permanently Denied",
//       middleText:
//           "Location permission is permanently denied. Please enable it in the app settings.",
//       onConfirm: () => openAppSettings(),
//       textConfirm: "Open Settings",
//       onCancel: () => Get.back(),
//       textCancel: "Cancel",
//     );
//   }
// }
