import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_assets.dart';
import 'package:v_ranger/core/values/app_colors.dart';

import 'package:v_ranger/core/values/app_values.dart';
import 'package:v_ranger/features/dashboard/domain/menu_code.dart';
import 'package:v_ranger/features/dashboard/domain/menu_item.dart';
import 'package:v_ranger/features/dashboard/presentation/controllers/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  final Function(MenuCode menuCode) onNewMenuSelected;

  BottomNavBar({
    required this.onNewMenuSelected,
    Key? key,
  }) : super(key: key);

  final BottomNavController navController = Get.find();

  final Key bottomNavKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const Color selectedItemColor = AppColors.secondaryColor;
    const Color unselectedItemColor = AppColors.textColorGreyDark;
    final List<BottomNavItem> navItems = _getNavItems();

    return Obx(
      () => Container(
        color: navController.selectedIndex == 2
            ? AppColors.primaryColor
            : Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppValues.radius_18),
                topLeft: Radius.circular(AppValues.radius_18)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.grey200, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppValues.radius_18),
              topRight: Radius.circular(AppValues.radius_18),
            ),
            child: BottomBar(
              selectedIndex: navController.currentPage.value,
              onTap: (int index) {
                navController.pageController.jumpToPage(index);
                navController.currentPage.value = index;
              },
              items: <BottomBarItem>[
                BottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home'),
                  activeColor: Colors.blue,
                ),
                BottomBarItem(
                  icon: Icon(Icons.favorite),
                  title: Text('Favorites'),
                  activeColor: Colors.red,
                ),
                BottomBarItem(
                  icon: Icon(Icons.person),
                  title: Text('Account'),
                  activeColor: Colors.greenAccent.shade700,
                ),
                BottomBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                  activeColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BottomNavItem> _getNavItems() {
    return [
      BottomNavItem(
        navTitle: 'Home',
        iconSvgName: AppAssets.appLogo,
        menuCode: MenuCode.home,
        height: AppValues.height_25,
        isChangeColor: true,
        padding: AppValues.padding_7,
      ),
      BottomNavItem(
        navTitle: 'Leaderboard',
        iconSvgName: AppAssets.appLogo,
        menuCode: MenuCode.leaderboard,
        height: AppValues.height_25,
        isChangeColor: true,
        padding: AppValues.padding_7,
      ),
      BottomNavItem(
        navTitle: 'Profile',
        iconSvgName: AppAssets.appLogo,
        menuCode: MenuCode.profile,
        height: AppValues.height_40,
        isChangeColor: false,
        padding: AppValues.padding_0,
      ),
      BottomNavItem(
        navTitle: 'Settings',
        iconSvgName: AppAssets.appLogo,
        menuCode: MenuCode.settings,
        height: AppValues.height_25,
        isChangeColor: true,
        padding: AppValues.padding_7,
      ),
    ];
  }
}
