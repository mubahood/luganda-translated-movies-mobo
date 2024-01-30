import 'dart:async';

import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:omulimisa2/utils/AppConfig.dart';

import '../../../../controllers/MainController.dart';
import "../../../../core/styles.dart";
import '../../../../screens/home/HomeScreen.dart';
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

    await Utils.initOneSignal(mainController.loggedInUser);
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
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppStyles.secondaryColor,
                  size: 40,
                ),
              ),
            ],
          ),
        )));
  }
}
