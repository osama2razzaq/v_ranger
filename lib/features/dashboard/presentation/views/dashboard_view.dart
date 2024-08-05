import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/values.dart';
import 'package:v_ranger/features/dashboard/domain/menu_code.dart';
import 'package:v_ranger/features/dashboard/presentation/controllers/bottom_nav_controller.dart';
import 'package:v_ranger/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:v_ranger/features/dashboard/presentation/widgets/bottom_nav_bar.dart';
import 'package:v_ranger/features/home/presentation/views/home_view.dart';
import 'package:v_ranger/features/profile/presentation/views/profile_view.dart';
import 'package:v_ranger/features/leaderboard/presentation/views/leaderboard_view.dart';
import 'package:v_ranger/features/settings/presentation/views/settings_view.dart';

class DashboardView extends StatelessWidget {
  DashboardView({super.key});
  final BottomNavController controller = Get.put(BottomNavController());
  final DashboardController dashboardController =
      Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        children: [
          Container(
            color: Colors.white,
            child: const HomeView(),
          ),
          Container(
            color: Colors.white,
            child: const LeaderboardView(),
          ),
          Container(
            color: Colors.white,
            child: const ProfileView(),
          ),
          Container(
            color: Colors.white,
            child: const SettingsView(),
          ),
        ],
        onPageChanged: (index) {
          controller.changePage(index);
        },
      ),
      bottomNavigationBar: Obx(
        () => BottomBar(
          selectedIndex: controller.currentPage.value,
          onTap: (int index) {
            controller.pageController.jumpToPage(index);
            controller.changePage(index);
          },
          items: const <BottomBarItem>[
            BottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: AppColors.batchBlue,
            ),
            BottomBarItem(
              icon: Icon(Icons.leaderboard),
              title: Text('Leaderboard'),
              activeColor: AppColors.red,
            ),
            BottomBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: AppColors.gradientEndColor),
            BottomBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: AppColors.yellow,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? bottomNavigationBar() => BottomNavBar(
      onNewMenuSelected: (menuCode) =>
          dashboardController.onMenuSelected(menuCode));

  Widget getPageOnSelectedMenu(MenuCode menuCode) {
    switch (menuCode) {
      case MenuCode.home:
        return Container();
      case MenuCode.leaderboard:
        return Container();
      case MenuCode.profile:
        return Container();
      case MenuCode.settings:
        return Container();

      default:
        return Container();
    }
  }
}
