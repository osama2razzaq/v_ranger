import 'package:flutter/material.dart';
import 'package:v_ranger/core/values/app_assets.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor.withOpacity(0.2),
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Center(
            child: Text(
              "Profile",
              style: PromptStyle.appBarTitleStyle,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
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
                    child: _userInfoForm(context)

                    //  Container(
                    //   height: 58,
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 0.0, vertical: 10.0),
                    //   margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //   decoration: BoxDecoration(
                    //       color: AppColors.colorWhite,
                    //       // Alternate row colors for better readability
                    //       borderRadius: BorderRadius.circular(10.0),
                    //       border: Border.all(color: Colors.red)),
                    // )),
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
          backgroundColor: AppColors.primaryColor,
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
          style: PromptStyle.profileNameStyle,
        ),
        // _buildPrgressbar(),
      ],
    );
  }

  Widget _userInfoForm(BuildContext context) {
    final List<Map<String, String>> items = [
      {'title': 'User Name', 'subtitle': 'David'},
      {'title': 'Full Name', 'subtitle': 'David Json'},
      {'title': 'IC No', 'subtitle': '*********1313'},
      {'title': 'Phone No', 'subtitle': '01231414141'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(15.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: AppColors.boaderColor),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                items[index]['title']!,
                style: PromptStyle.profileTitle,
              ),
              subtitle: Text(
                items[index]['subtitle']!,
                style: PromptStyle.profileSubTitle,
              ),
            ),
          ),
        );
      },
    );
  }
}