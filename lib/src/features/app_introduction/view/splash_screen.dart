import 'dart:async';

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:moviebox/utils/AppConfig.dart';

import '../../../../controllers/MainController.dart';
import "../../../../core/styles.dart";
import '../../../../screens/shop/screens/shop/full_app/full_app.dart';
import '../../../../utils/Utilities.dart';
import '../../../routing/routing.dart';
import 'onboarding_screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  Future<void> initializeApp() async {
    Utils.init_theme();
    await mainController.getLoggedInUser();
    Utils.system_boot();
    await Future.delayed(const Duration(seconds: 4));

    if (mainController.loggedInUser.id < 1) {
      Get.to(() => OnBoardingScreen());
      return;
    }

    // await Utils.initOneSignal(mainController.loggedInUser);
    Get.offAll(() => const HomeScreen());
    return;
    // Perform initialization logic here
    // For example, you can fetch data, initialize services, etc.

    // Simulate a delay for the splash screen
    Timer(const Duration(seconds: 3), () {
      // After the delay, navigate to the next screen
      AppRouter.goToOnBoarding();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.backgroundWhite,
        body: SafeArea(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  initializeApp();
                },
                child: Image.asset(
                  AppConfig.logo_1,
                  width: 70,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                  child: Text(
                AppConfig.APP_NAME,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
        )));
  }
}
