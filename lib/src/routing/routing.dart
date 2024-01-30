import 'package:get/get.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/farmer_profiling/FarmerProfilingStep2Screen.dart';
import '../../screens/farmer_profiling/FarmerProfilingStep3Screen.dart';
import '../../screens/home/HomeScreen.dart';
import '../features/app_introduction/view/onboarding_screens.dart';
import '../features/app_introduction/view/splash_screen.dart';
import '../features/authentication/view/signup_screen.dart';
import '../features/home/view/resource_category_screen.dart';
import '../features/home/view/resource_subcategory_screen.dart';
import '../features/home/view/training_session_screen.dart';
import '../features/home/view/update_profile.dart';

class AppRouter {
  static const String splash = '/';
  static const String onBoarding = '/onBoarding';
  static const String register = '/register';
  static const String login = '/login';
  static const String home = '/homeScreen';
  static const String resource = '/resources';
  static const String selectResourceCategory = '/selectResourceCategory';
  static const String updateProfile = '/updateProfile';
  static const String searchSubCategory = '/subCategory';
  static const String trainingSession = '/trainingSession';
  static const String trainingListScreen = '/trainingListScreen';
  static const String farmerProfilingScreenTwo = '/farmerScreenTwo';
  static const String farmerProfilingScreenThree = '/farmerScreenThree';
  static final List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: onBoarding,
      page: () => OnBoardingScreen(),
    ),
    GetPage(
      name: register,
      page: () => const CreateAccountScreen(),
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: selectResourceCategory,
      page: () => const SelectCategoryScreen(),
    ),
    GetPage(
      name: updateProfile,
      page: () => UpdateProfileScreen(),
    ),
    GetPage(
      name: searchSubCategory,
      page: () => SearchSubCategoryScreen(),
    ),
    GetPage(
      name: trainingSession,
      page: () => const TrainingSessionsScreen (),
    ),
    GetPage(
      name: farmerProfilingScreenTwo,
      page: () => const FarmerProfilingStep2Screen(),
    ),
    GetPage(
      name: farmerProfilingScreenThree,
      page: () => const FarmerProfilingStep3Screen(),
    ),
  ];

  static void goToSplash() {
    Get.offAllNamed(splash);
  }

  static void goToOnBoarding() {
    Get.offAllNamed(onBoarding);
  }

  static void goToRegister() {
    Get.toNamed(register);
  }

  static void goToLogin() {
    Get.toNamed(login);
  }
  static void goToHome() {
    Get.toNamed(home);
  }
  static void goToUpdateProfile() {
    Get.toNamed(updateProfile);
  }
}
