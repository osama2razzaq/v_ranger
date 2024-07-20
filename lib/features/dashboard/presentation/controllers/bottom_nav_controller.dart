import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  final RxInt _selectedIndexController = 0.obs;
  final pageController = PageController();

  RxInt currentPage = 0.obs;

  void changePage(int index) {
    currentPage.value = index;
  }

  void updateSelectedIndex(int index) {
    _selectedIndexController(index);
  }

  int get selectedIndex => _selectedIndexController.value;
}
