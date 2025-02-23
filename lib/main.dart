import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/routing/app_pages.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/features/Survey/presentation/controllers/upload_survey_controller.dart';
import 'package:v_ranger/features/login/presentation/controllers/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebadeMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase
      .initializeApp(); // options: DefaultFirebaseConfig.platformOptions
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Request notification permissions on iOS (optional for Android)

  // Initialize the AuthService
  final authService = AuthService();
  final token = await authService.getAccessToken();
  final isFingerprintEnabled = await authService.getisFingerprintEnabled();

  // Determine the initial route based on the token

  final initialRoute = (token != null && isFingerprintEnabled == true)
      ? Routes.fingerprintAuth
      : (token != null)
          ? Routes.dashboard
          : Routes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SnackBarHelper {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final UploadSurveyController surveyFormController =
      Get.put(UploadSurveyController());
  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      // developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
    if (_connectionStatus.first == ConnectivityResult.none) {
      showNoInternetSnackBar();
    } else {
      showNormalSnackBar('Internet connection is available');
      surveyFormController.postPendingSurveys();
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryColor, // Set your desired color here
    ));

    return GetMaterialApp(
      title: '',

      debugShowCheckedModeBanner: false,
      locale: Get.deviceLocale,
      initialRoute: widget.initialRoute,
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
