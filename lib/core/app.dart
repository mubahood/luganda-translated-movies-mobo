import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:omulimisa2/screens/gardens/GardensScreen.dart";

import "../src/features/app_introduction/view/splash_screen.dart";
import "../src/routing/routing.dart";
import "../utils/app_theme.dart";

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    AppTheme.init();

    return GetMaterialApp(
      title: 'mOmulimisa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      //home: OnBoardingScreen(),
      home: GardensScreen(),
      initialRoute: AppRouter.splash,
      getPages: AppRouter.routes,
    );
  }
}