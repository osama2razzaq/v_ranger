import 'package:get/get.dart';
import 'package:v_ranger/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:v_ranger/features/login/presentation/views/login_view.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.main;

  static final routes = [
    GetPage(name: Routes.main, page: () => LoginView()),
    //binding: SplashBinding()),
    //  GetPage(name: Routes.home, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: Routes.dashboard,
      page: () => DashboardView(),
    ),
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
    ),
    //   GetPage(
    //       name: Routes.termsCondtions,
    //       page: () => TermsConditionsView(),
    //       binding: TermsConditionsBinding()),
  ];
}
