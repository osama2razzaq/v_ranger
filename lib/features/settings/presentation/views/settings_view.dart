import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/change_password/presentation/views/change_password_view.dart';
import 'package:v_ranger/features/settings/presentation/controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});
  final SettingsController controller = Get.put(SettingsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Center(
            child: Text(
              "Settings",
              style: PromptStyle.appBarTitleStyle,
            ),
          ),
        ),
        body: SafeArea(
            child: Container(
                child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _settingItem(
              context,
              Icons.notifications,
              'Notifications',
              () {},
            ),
            _fingerprintToggleItem(context),
            _settingItem(
              context,
              Icons.lock,
              'Change Password',
              () {
                Get.to(() => ChangePasswordView());
              },
            ),
            _settingItem(
              context,
              Icons.privacy_tip,
              'Privacy Policy', // New Privacy Policy item
              () {
                _launchPrivacyPolicy();
              },
            ),
            _settingItem(
              context,
              Icons.logout,
              'Logout',
              () {
                controller.showLogoutAlert();
              },
            ),
          ],
        ))));
  }

  void _launchPrivacyPolicy() async {
    const url = 'https://itgtel.com/privacy-policy/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _fingerprintToggleItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: 55,
        padding: const EdgeInsets.all(16.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.fingerprint),
                SizedBox(width: 16.0),
                Text('Fingerprint Enable',
                    style: PromptStyle
                        .profileSubTitle), // Use your text style here
              ],
            ),
            Obx(() {
              return Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: controller.isFingerprintEnabled.value,
                  onChanged: (value) {
                    controller.toggleFingerprint(value);
                  },
                  activeColor: AppColors.primaryColor,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

Widget _settingItem(
    BuildContext context, IconData icon, String title, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon),
                SizedBox(width: 16.0),
                Text(
                  title,
                  style: PromptStyle.profileSubTitle,
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ),
    ),
  );
}
