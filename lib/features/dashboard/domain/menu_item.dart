import 'menu_code.dart';

class BottomNavItem {
  final String navTitle;
  final String iconSvgName;
  final MenuCode menuCode;
  final bool isChangeColor;
  final double height;
  final double padding;

  const BottomNavItem(
      {required this.navTitle,
      required this.iconSvgName,
      required this.menuCode,
      required this.isChangeColor,
      required this.height,
      required this.padding});
}
