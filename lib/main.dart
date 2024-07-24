import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/routing/app_pages.dart';
import 'package:v_ranger/core/values/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor, // Set your desired color here
    ));
    return GetMaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      initialRoute: AppPages.initial,
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
