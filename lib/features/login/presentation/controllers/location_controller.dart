import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  var currentLocation = Rxn<LocationData>();
  final Location _location = Location();

  @override
  void onInit() {
    super.onInit();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      // Check if location services are enabled
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      // Check location permissions
      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      // Get the current location
      currentLocation.value = await _location.getLocation();
    } catch (e) {
      print('Error: $e');
    }
  }
}
