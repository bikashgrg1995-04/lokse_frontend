import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/core/theme/app_theme.dart';

import '../routes/app_pages.dart';
import '../routes/app_routes.dart';
import '../bindings/initial_binding.dart';

class LokseApp extends StatelessWidget {
  const LokseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lokse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
