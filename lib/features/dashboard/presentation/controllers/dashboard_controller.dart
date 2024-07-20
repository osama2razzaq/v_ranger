import 'package:get/get.dart';
import 'package:v_ranger/features/dashboard/domain/menu_code.dart';

class DashboardController extends GetxController {
  final Rx<MenuCode> _selectedMenuCodeController = MenuCode.home.obs;

  MenuCode get selectedMenuCode => _selectedMenuCodeController.value;

  final RxBool lifeCardUpdateController = false.obs;

  Future<void> onMenuSelected(MenuCode menuCode) async {
    _selectedMenuCodeController(menuCode);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
