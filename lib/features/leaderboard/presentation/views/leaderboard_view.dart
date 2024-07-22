import 'package:flutter/material.dart';
import 'package:v_ranger/core/common_widgets/circular_progressbar.dart';
import 'package:v_ranger/core/common_widgets/progress_bar.dart';
import 'package:v_ranger/core/values/app_assets.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                color: AppColors.profileBackgroundColor,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_buildProfileImage(), _buildProfileName()],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    color: Colors.white, // Example background color
                  ),
                  child: Container(
                    height: 500,
                    width: MediaQuery.sizeOf(context).width,
                    child: _buildListView(),
                  ),
                ),
              )
            ],
          ),
        ));
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

  Widget _buildProfileName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "David",
          style: PromptStyle.leaderboardProfileNameStyle,
        ),
        _buildPrgressbar(),
      ],
    );
  }

  Widget _buildPrgressbar() {
    return const ProgressBar(
      count: 4,
      totalCount: '5',
    );
  }

  Widget _buildListView() {
    final List<Map<String, dynamic>> dataList = [
      {
        'no': '1',
        'score': '90',
        'fullname': 'John',
        'assign': '4',
        'complete': '4',
        'pending': '0'
      },
      {
        'no': '2',
        'score': '85',
        'fullname': 'Danial',
        'assign': '7',
        'complete': '4',
        'pending': '3'
      },
      {
        'no': '3',
        'score': '95',
        'fullname': 'EMY',
        'assign': '3',
        'complete': '0',
        'pending': '3'
      },
      {
        'no': '4',
        'score': '95',
        'fullname': 'Osama',
        'assign': '10',
        'complete': '9',
        'pending': '1'
      },
      // Add more data as needed
    ];
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

    return Column(children: <Widget>[
      Expanded(
        child: ListView.builder(
          itemCount: dataList.length + 1, // +1 for the header row
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              // Header row
              return Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    _buildHeaderItem('No', flex: 1),
                    _buildHeaderItem('Score', flex: 1),
                    _buildHeaderItem('Fullname', flex: 1),
                    _buildHeaderItem('Assign', flex: 1),
                    _buildHeaderItem('Complete', flex: 1),
                    _buildHeaderItem('Pending', flex: 1),
                  ],
                ),
              );
            }

            // Subtracting 1 to get correct index for data list
            final rowData = dataList[index - 1];
            // Subtracting 1 to get correct index for data list
            int assign = int.parse(rowData['assign']);
            int complete = int.parse(rowData['complete']);
            int pending = int.parse(rowData['pending']);
            int percentage =
                assign != 0 ? ((complete / assign) * 100).round() : 0;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: BoxDecoration(
                color: getColorBasedOnPercentage(
                    percentage), // AppColors.scoreBgColor,
                // Alternate row colors for better readability
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
                  _buildDataItem(rowData['no'], flex: 1),
                  _buildDataScore(
                      rowData['score'],
                      flex: 1,
                      percentage,
                      assign,
                      pending,
                      complete),
                  _buildDataItem(rowData['fullname'], flex: 2),
                  _buildDataItem(rowData['assign'], flex: 1),
                  _buildDataItem(rowData['complete'], flex: 1),
                  _buildDataItem(rowData['pending'], flex: 1),
                ],
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildHeaderItem(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: PromptStyle.leaderboardHeaderTitle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataScore(
      String text, int percentage, int complete, int pending, int assign,
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
        //  height: 50,

        child: MyCircularPercentIndicator(
          totalValue: assign, // Set your total value here
          leftValue: pending, // Set your left value here
          color: getColorBasedOnPercentage(percentage),
        ),
      ),
    );
  }

  Widget _buildDataItem(String text, {int flex = 1}) {
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
