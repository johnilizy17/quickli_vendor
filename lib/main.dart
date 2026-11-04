import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/config/app_config.dart';
import 'app/constants/color_constant.dart';
import 'app/routes/app_pages.dart';
import 'app/services/api_service.dart';
import 'app/services/main_storage.dart';
import 'app/utils/app_logger.dart';
import 'app/widgets/startup/startup_failure_screen.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MainStorage());
    Get.put(ApiService(), permanent: true);
  }
}

/// Boots the app, turning any startup failure into a visible screen.
Future<void> bootstrap() async {
  try {
    await _runAppWithEnv();
  } catch (error, stack) {
    appLog('Startup failed: $error');
    debugPrintStack(stackTrace: stack);
    runApp(
      StartupFailureScreen(
        title: 'Startup failed',
        message: error.toString(),
        details: stack.toString(),
      ),
    );
  }
}

Future<void> _runAppWithEnv() async {
  WidgetsFlutterBinding.ensureInitialized();

  appLog('Environment: ${AppConfig.envName} -> ${AppConfig.baseUrl}');

  for (final warning in AppConfig.warnings) {
    appLog('Config warning: $warning');
  }

  final issues = AppConfig.problems;
  if (issues.isNotEmpty) {
    appLog('Startup blocked: ${issues.join(' / ')}');
    runApp(StartupFailureScreen(
      title: 'Build is misconfigured',
      message: issues.join('\n\n'),
      details: AppConfig.missingKeysHelp,
    ));
    return;
  }

  await GetStorage.init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const QuickliVendorApp());
}

Future<void> main() async => await bootstrap();

class QuickliVendorApp extends StatelessWidget {
  const QuickliVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      child: GetMaterialApp(
        title: 'Quickli Vendor',
        debugShowCheckedModeBanner: false,
        locale: const Locale('en', ''),
        initialBinding: InitialBindings(),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: ThemeData(
          fontFamily: GoogleFonts.openSans().fontFamily,
          colorScheme: ColorScheme.fromSeed(seedColor: ColorConstant.brandColor),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: ColorConstant.samantic),
            titleTextStyle: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: ColorConstant.samantic,
            ),
          ),
        ),
      ),
    );
  }
}
