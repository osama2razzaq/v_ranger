import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v_ranger/core/common_widgets/form_loader.dart';
import 'package:v_ranger/core/values/values.dart';
import 'package:v_ranger/features/batches/presentation/views/batchesList_view.dart';
import 'package:v_ranger/features/batches/presentation/views/batches_tabs_view.dart';
import 'package:v_ranger/features/dashboard/data/Model/dashboard_model.dart';
import 'package:v_ranger/features/home/presentation/controllers/home_controller.dart';
import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final LocationController locationController = Get.put(LocationController());
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Center(
            child: Text(
              "V-RANGER",
              style: PromptStyle.appBarLogoStyle,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [_buildGoogleMap(), _buildBottomContainer()],
          ),
        ));
  }

  Widget _buildGoogleMap() {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        child: Obx(() {
          if (controller.data.value == null) {
            return const Center(child: FormLoader());
          }

          markers = _createMarkersFromData(controller.data.value!);

          return GoogleMap(
            myLocationEnabled: true,
            scrollGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {},
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                  3.1458, 101.6639), // Set the initial position of the camera
              zoom: 10, // Set the initial zoom level
            ),
            markers: markers.toSet(),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          );
        }),
      ),
    );
  }

  List<Marker> _createMarkersFromData(DashboardModel data) {
    List<Marker> markers = [];
    data.batches?.forEach((batch) {
      batch.batchDetails?.forEach((detail) {
        markers.add(
          Marker(
              markerId: MarkerId(detail.id.toString()),
              position: LatLng(
                double.parse(detail.batchfileLatitude ?? '0'),
                double.parse(detail.batchfileLongitude ?? '0'),
              ),
              infoWindow: InfoWindow(
                title: detail.address,
                snippet: 'Batch: ${batch.batchNo}',
              ),
              onTap: () {
                print(batch.id);
                Get.to(() => BatchesTabsView(
                      batchId: '${batch.id}',
                    ));
              }),
        );
      });
    });
    return markers;
  }

  Widget _buildBottomContainer() {
    return Obx(() {
      final data = controller.data.value;
      final totalBatches = data?.totalBatches?.toString() ?? '0';
      final totalFiles = data?.totalBatchDetails?.toString() ?? '0';
      final completedFiles =
          data?.totalCompletedBatchDetails?.toString() ?? '0';

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCard(
                'Batch',
                totalBatches,
                Icons.layers,
                AppColors.batchBlue,
                () {
                  //Get.to(const BatchesView());
                  Get.to(() => BatchesListView());
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCard(
                'Total Files',
                totalFiles,
                Icons.folder,
                AppColors.fileRed,
                () {
                  //Get.to(const BatchesView());
                  Get.to(() => const BatchesTabsView(
                        batchId: '',
                      ));
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildCard(
                'Completed',
                completedFiles,
                Icons.check_circle,
                AppColors.fileYellow,
                () {
                  //Get.to(const BatchesView());
                  Get.to(() => const BatchesTabsView(
                        batchId: '',
                        isCompleted: true,
                      ));
                },
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCard(String title, String count, IconData icon, Color color,
      final VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //width: 100,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: PromptStyle.cardTitle,
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: PromptStyle.cardSubTitle,
            ),
            const SizedBox(height: 10),
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
