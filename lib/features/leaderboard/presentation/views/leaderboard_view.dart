import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/circular_progressbar.dart';
import 'package:v_ranger/core/common_widgets/form_loader.dart';
import 'package:v_ranger/core/common_widgets/progress_bar.dart';
import 'package:v_ranger/core/values/app_assets.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/leaderboard/data/Model/leaderboard_details_model.dart';
import 'package:v_ranger/features/leaderboard/presentation/controllers/leaderboard_controller.dart';

class LeaderboardView extends StatelessWidget {
  LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the instance of LeaderboardController
    final LeaderboardController controller = Get.put(LeaderboardController());

    // Call the API method when the view is built
    controller.fetchLeaderboardData();
    return Scaffold(
      backgroundColor: AppColors.profileBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Center(
          child: Text(
            "Leaderboard",
            style: PromptStyle.appBarTitleStyle,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.data.value == null) {
            // Show a loading spinner or some placeholder
            return const Center(child: FormLoader());
          }

          final requestedDriver = controller.data.value!.requestedDriver;
          final otherDrivers = controller.data.value!.otherDrivers;

          return Column(
            children: [
              _buildProfileSection(requestedDriver),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: Colors.white,
                  ),
                  child: _buildListView(otherDrivers!),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileSection(RequestedDriver? requestedDriver) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      color: AppColors.profileBackgroundColor,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileImage(),
            _buildProfileName(requestedDriver),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          radius: 55,
          backgroundColor: AppColors.profileColor,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                AppAssets.profileImage,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileName(RequestedDriver? requestedDriver) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          requestedDriver!.driverName!,
          style: PromptStyle.leaderboardProfileNameStyle,
        ),
        _buildPrgressbar(requestedDriver),
      ],
    );
  }

  Widget _buildPrgressbar(RequestedDriver? requestedDriver) {
    final totalCount = requestedDriver!.statusCounts?.assigned;
    final count = requestedDriver.statusCounts?.completed;
    return ProgressBar(
      count: int.parse(count!),
      totalCount: '$totalCount',
    );
  }

  Widget _buildListView(List<OtherDriver> otherDrivers) {
    Color getColorBasedOnPercentage(int percentage) {
      if (percentage == 100) {
        return AppColors.scoreBgColor1;
      } else if (percentage >= 75) {
        return AppColors.scoreBgColor2;
      } else if (percentage >= 50) {
        return AppColors.scoreBgColor3;
      } else {
        return AppColors.scoreBgColor3;
      }
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: otherDrivers.length + 1, // +1 for the header row
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                // Header row
                return Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      _buildHeaderItem('No', flex: 0),
                      _buildHeaderItem('Score', flex: 1),
                      _buildHeaderItem('Fullname', flex: 1),
                      _buildHeaderItem('Assign', flex: 1),
                      _buildHeaderItem('Complete', flex: 1),
                      _buildHeaderItem('Pending', flex: 1),
                    ],
                  ),
                );
              }

              final driver = otherDrivers[index - 1];
              int assign = driver.statusCounts?.assigned ?? 0;
              int complete =
                  int.tryParse(driver.statusCounts?.completed ?? '0') ?? 0;
              int pending =
                  int.tryParse(driver.statusCounts?.pending ?? '0') ?? 0;
              int percentage =
                  assign != 0 ? ((complete / assign) * 100).round() : 0;

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration: BoxDecoration(
                  color: getColorBasedOnPercentage(percentage),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildDataItem('$index', flex: 1),
                    _buildDataScore(driver.statusCounts?.completed ?? '0',
                        percentage, complete, assign),
                    _buildDataItem(driver.driverName ?? '', flex: 2),
                    _buildDataItem('$assign', flex: 1),
                    _buildDataItem('${complete}', flex: 1),
                    _buildDataItem('${pending}', flex: 1),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderItem(text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: PromptStyle.leaderboardHeaderTitle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataScore(text, int percentage, int complete, int assign,
      {int flex = 1}) {
    Color getColorBasedOnPercentage(int percentage) {
      if (percentage == 100) {
        return AppColors.green;
      } else if (percentage >= 75) {
        return AppColors.yellow;
      } else if (percentage >= 50) {
        return AppColors.red;
      } else {
        return AppColors.red;
      }
    }

    return Expanded(
      flex: flex,
      child: Container(
        child: MyCircularPercentIndicator(
          totalValue: assign,
          leftValue: complete,
          color: getColorBasedOnPercentage(percentage),
        ),
      ),
    );
  }

  Widget _buildDataItem(text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.scoreHeader,
        ),
      ),
    );
  }
}
