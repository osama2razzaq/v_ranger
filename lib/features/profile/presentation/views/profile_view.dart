import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_assets.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/profile/presentation/controllers/profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

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
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                color: Colors.transparent,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      _buildProfileImage(),
                      _buildProfileName(controller),
                    ],
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
                    child: _userInfoForm(context, controller)),
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

  Widget _buildProfileName(ProfileController controller) {
    return Obx(() {
      final profile = controller.data.value?.profile;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile?.name ?? "Loading...",
            style: PromptStyle.profileNameStyle,
          ),
          // _buildProgressBar(),
        ],
      );
    });
  }

  Widget _userInfoForm(BuildContext context, ProfileController controller) {
    return Obx(() {
      final profile = controller.data.value;

      if (profile == null) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryColor,
          ),
        );
      }

// Hide first two and last two characters of the IC number
      String maskedIcNo = profile.profile!.icNumber.toString();
      if (maskedIcNo.length <= 12) {
        maskedIcNo =
            '***' + maskedIcNo.substring(3, maskedIcNo.length - 3) + '***';
      }
      final List<Map<String, String>> items = [
        {
          'title': 'User Name',
          'subtitle': profile.profile!.username.toString()
        },
        {'title': 'Full Name', 'subtitle': profile.profile!.name.toString()},
        {'title': 'IC No', 'subtitle': maskedIcNo},
        {
          'title': 'Phone No',
          'subtitle': profile.profile!.phoneNumber.toString()
        },
      ];

      return Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            child: SizedBox(
              child: Text('Your Information',
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyPrompt,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  )),
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                    child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index]['title']!,
                              style: PromptStyle.profileTitle,
                            ),
                            Text(
                              items[index]['subtitle']!,
                              style: PromptStyle.profileSubTitle,
                            ),
                          ],
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
