import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moviebox/models/LoggedInUserModel.dart';
import 'package:moviebox/screens/auth/login_screen.dart';
import 'package:moviebox/utils/Utilities.dart';
import 'package:moviebox/utils/my_colors.dart';

import '../../../../screens/shop/screens/shop/full_app/full_app.dart';
import '../../../../utils/AppConfig.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.primary,
          foregroundColor: MyColors.primary,
          surfaceTintColor: MyColors.primary,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: MyColors.primary,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        backgroundColor: MyColors.primary,
        body: newScreen());
  }

  newScreen() {
    return Center(
      child: InkWell(
        onTap: () {
          myInit();
        },
        child: Image(
          image: const AssetImage(AppConfig.logo_1),
          width: Get.width / 2,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  LoggedInUserModel u = LoggedInUserModel();

  void myInit() async {
    u = await LoggedInUserModel.getLoggedInUser();
    await Future.delayed(const Duration(seconds: 3));
    if (u.id < 1) {
      Get.off(() => const LoginScreen());
      return;
    }
    Utils.toast("Welcome ${u.name}!");
    Get.off(() => const HomeScreen());
  }
}
