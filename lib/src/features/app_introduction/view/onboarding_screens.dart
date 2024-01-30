import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/core/styles.dart';

import '../../../routing/routing.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.backgroundWhite,
      body: OnBoard(
        pageController: _pageController,

        // onSkip: () {
        //   // print('skipped');
        // },

        // onDone: () {
        //   // print('done tapped');
        // },
        onBoardData: onBoardData,
        titleStyles: AppStyles.googleFontMontserrat.copyWith(
            fontSize: 18, color: AppStyles.black, fontWeight: FontWeight.w700),
        descriptionStyles: AppStyles.googleFontMontserrat.copyWith(
            fontSize: 14, color: AppStyles.black, fontWeight: FontWeight.w400),
        pageIndicatorStyle: const PageIndicatorStyle(
          width: 77,
          inactiveColor: AppStyles.secondaryColor,
          activeColor: AppStyles.secondaryColor,
          inactiveSize: Size(10, 10),
          activeSize: Size(20, 20),
        ),
        // Either Provide onSkip Callback or skipButton Widget to handle skip state
        skipButton: TextButton(
          onPressed: () {
            AppRouter.goToLogin();
          },
          child: Text(
            "Skip",
            style: AppStyles.googleFontMontserrat.copyWith(
                color: AppStyles.textHighlightColor,
                fontWeight: FontWeight.w700),
          ),
        ),
        // Either Provide onDone Callback or nextButton Widget to handle done state
        nextButton: OnBoardConsumer(
          builder: (context, ref, child) {
            final state = ref.watch(onBoardStateProvider);
            return InkWell(
              onTap: () => _onNextTap(state),
              child: Container(
                width: 230,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppStyles.primaryColor),
                child: Text(
                  state.isLastPage ? "Get Started" : "Next",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState onBoardState) {
    if (!onBoardState.isLastPage) {
      _pageController.animateToPage(
        onBoardState.page + 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutSine,
      );
    } else {
      Get.offAllNamed(AppRouter.login);
      //AppRouter.goToLogin();
    }
  }
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Farmers Connect",
    description:
        "Welcome to Farmers Connect! 🌾🚜 Join our thriving community of farmers where you can share your expertise, connect with fellow farmers, and access valuable resources to enhance your farming journey. Whether you're a seasoned pro or just starting out, we're here to support you every step of the way. Let's grow together!",
    imgUrl: "assets/images/onboarding1.jpg",
  ),
  const OnBoardModel(
    title: "AgriHub: Your Farming Companion",
    description:
        "AgriHub is your one-stop destination for all things agriculture. 🌱👩‍🌾 We're delighted to have you on board! Here, you'll find a warm and welcoming community of farmers eager to share knowledge, discuss the latest trends, and exchange tips and tricks. Whether you're a hobbyist or a commercial farmer, AgriHub is your trusted farming companion.",
    imgUrl: 'assets/images/onboarding2.jpg',
  ),
  const OnBoardModel(
    title: "HarvestChat: Where Farmers Unite",
    description:
        "Welcome to HarvestChat, the virtual gathering place for farmers like you! 🌻🤝 We're excited to have you as part of our growing family. Join the conversation, ask questions, and connect with farmers from around the world. HarvestChat is the place to be for those who are passionate about farming. Let's sow the seeds of friendship and knowledge together!",
    imgUrl: 'assets/images/onboarding3.jpg',
  ),
];
