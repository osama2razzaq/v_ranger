import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
            _settingItem(
              context,
              Icons.fingerprint,
              'Fingerprint Enable',
              () {},
            ),
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
              Icons.logout,
              'Logout',
              () {
                controller.showPermissionAlert();
              },
            ),
          ],
        ))));
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
                  Text(title),
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
}
