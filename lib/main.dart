import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/routing/app_pages.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/features/login/presentation/controllers/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the AuthService
  final authService = AuthService();
  final token = await authService.getAccessToken();

  // Determine the initial route based on the token
  print("token== $token");
  final initialRoute = token != null ? Routes.dashboard : Routes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor, // Set your desired color here
    ));
    return GetMaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      // translations: Apptranslations(),
      // fallbackLocale: Apptranslations.fallbackLocale,
      // theme: AppTheme.mainTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
