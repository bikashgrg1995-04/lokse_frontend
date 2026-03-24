import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lokse/bindings/global_bindings.dart';
import 'package:lokse/core/theme/app_theme.dart';
import 'package:lokse/routes/app_pages.dart';
import 'package:lokse/routes/app_routes.dart';

class LokseApp extends StatelessWidget {
  const LokseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lokse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      initialBinding: GlobalBindings(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
