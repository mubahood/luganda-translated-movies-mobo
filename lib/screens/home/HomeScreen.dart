import 'dart:core';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/controllers/MainController.dart';
import 'package:omulimisa2/core/styles.dart';
import 'package:omulimisa2/screens/WeatherForeCastScreen.dart';
import 'package:omulimisa2/screens/farmer_profiling/FarmerGroupsScreen.dart';
import 'package:omulimisa2/screens/gardens/GardensScreen.dart';
import 'package:omulimisa2/src/routing/routing.dart';
import 'package:omulimisa2/utils/AppConfig.dart';
import 'package:omulimisa2/utils/Utilities.dart';
import 'package:omulimisa2/widget/circle_image.dart';

import '../../models/FarmerOfflineModel.dart';
import '../../models/MenuItem.dart';
import '../../models/img.dart';
import '../../src/features/home/view/update_profile.dart';
import '../../utils/my_colors.dart';
import '../../widget/my_text.dart';
import '../farmer_questions/FarmerQuestionsScreen.dart';
import '../resources/ResourcesScreen.dart';
import '../shop/screens/shop/full_app/full_app.dart';
import '../trainings/TrainingHomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

final MainController mainController = Get.find<MainController>();

class HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScreen();
  }

  List<MenuItem> menuItems = [];
  FarmerOfflineModel item = FarmerOfflineModel();

  Future<void> initScreen() async {
    await mainController.getLoggedInUser();
    //Utils.toast2(mainController.loggedInUser.permissions.length.toString());
    prepareMenu();
  }

  Future<void> prepareMenu() async {
    setState(() {
      menuItems.clear();
    });

    menuItems.add(MenuItem(
        'Farmer\nProfiling',
        Image.asset(
          'assets/images/menu_farmer.png',
          width: Get.width / 4.2,
        ),
        const Color(0xFF054215), () {
      Get.to(() => const FarmerGroupsScreen());
    }));
    if (mainController.canManageFarmers) {
      menuItems.add(MenuItem(
        'Farmer\nQuestions',
        Image.asset(
          'assets/images/menu_questions.png',
          width: Get.width / 4.2,
        ),
        const Color(0xFF070773),
        () {
          Get.to(() => const FarmerQuestionsScreen());
        },
      ));
    }

    menuItems.add(MenuItem(
        'Weather\nForecast',
        Image.asset(
          'assets/images/mymenuweather.png',
          width: Get.width / 4.2,
        ),
        const Color(0xFFC58100), () {
      Get.to(() => const WeatherForeCastScreen());
    }));

    menuItems.add(MenuItem(
        'Market\nPlace',
        Image.asset(
          'assets/images/market.png',
          width: Get.width / 4.2,
        ),
        const Color(0xFF860303), () {
      Get.to(() => const ShopApp());
    }));

    menuItems.add(MenuItem(
        'Garden\nMapping',
        Image.asset(
          'assets/images/menu_map.png',
          width: Get.width / 4.2,
        ),
        const Color(0xFF41009A), () {
      Get.to(() => const GardensScreen());
    }));

    menuItems.add(MenuItem(
        'Training\nPrograms',
        Image.asset(
          'assets/images/menu_training.png',
          width: Get.width / 4.2,
        ),
        const Color(0xFF015252), () {
      Get.to(() => const TrainingHomeScreen());
      //Get.toNamed(AppRouter.trainingSession);
    }));

    menuItems.add(MenuItem(
      'Digital\nResources',
      Image.asset(
        'assets/images/menu_resources.png',
        width: Get.width / 4.2,
      ),
      const Color(0xFF004639),
      () {
        // MyToast.show('Coming soon...', context);
        // return;
        Get.to(() => const ResourcesScreen());
      },
    ));

    menuItems.add(MenuItem(
      'My\nAccount',
      Image.asset(
        'assets/images/menu_profile.png',
        width: Get.width / 4.2,
      ),
      const Color(0xFFB04500),
      () {
        Get.to(() => UpdateProfileScreen());
      },
    ));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.bgLight,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0), child: Container()),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: initScreen,
            color: MyColors.primary,
            backgroundColor: CupertinoColors.lightBackgroundGray,
            child: Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        toolbarHeight: Get.height / 5,
                        titleSpacing: 0,
                        title: Container(
                          color: MyColors.bgLight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    color: MyColors.primary,
                                    width: double.infinity,
                                    height: Get.height / 4.7,
                                    child: Image.asset(Img.get('world_map.png'),
                                        fit: BoxFit.cover),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(height: 10),
                                            Text(
                                                "Hi, ${mainController.loggedInUser.name}",
                                                style: MyText.title(context)!
                                                    .copyWith(
                                                        color: Colors.white)),
                                            Container(height: 0),
                                            mainController.myRole.isEmpty
                                                ? const SizedBox()
                                                : Text(
                                                    mainController.myRole,
                                                    style:
                                                        MyText.caption(context)!
                                                            .copyWith(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: Colors
                                                                    .grey[200]),
                                                  ),
                                            Container(height: 10),
                                            Text(
                                                "Welcome to ${AppConfig.APP_NAME}.",
                                                style: MyText.caption(context)!
                                                    .copyWith(
                                                        color:
                                                            Colors.grey[200])),
                                          ],
                                        ),
                                        const Spacer(),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton2(
                                            customButton: const Icon(
                                              Icons.more_vert,
                                              size: 24,
                                              color: Colors.white,
                                            ),
                                            items: [
                                              ...MenuItems.firstItems.map(
                                                (item) => DropdownMenuItem<
                                                    DropMenuItem>(
                                                  value: item,
                                                  child:
                                                      MenuItems.buildItem(item),
                                                ),
                                              ),
                                              const DropdownMenuItem<Divider>(
                                                  enabled: false,
                                                  child: Divider()),
                                              ...MenuItems.secondItems.map(
                                                (item) => DropdownMenuItem<
                                                    DropMenuItem>(
                                                  value: item,
                                                  child:
                                                      MenuItems.buildItem(item),
                                                ),
                                              ),
                                            ],
                                            onChanged: (value) {
                                              MenuItems.onChanged(context,
                                                  value! as DropMenuItem);
                                            },
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              width: 160,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                color: Colors.white,
                                              ),
                                              offset: const Offset(0, 8),
                                            ),
                                            menuItemStyleData:
                                                MenuItemStyleData(
                                              customHeights: [
                                                ...List<double>.filled(
                                                    MenuItems.firstItems.length,
                                                    48),
                                                8,
                                                ...List<double>.filled(
                                                    MenuItems
                                                        .secondItems.length,
                                                    48),
                                              ],
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              /*Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                transform:
                                    Matrix4.translationValues(0.0, -35.0, 0.0),
                                child: Column(
                                  children: <Widget>[
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      color: Colors.white,
                                      elevation: 2,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      child: Container(
                                        color: Colors.white,
                                        height: 60,
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                                icon: const Icon(Icons.category,
                                                    color: Colors.black),
                                                onPressed: () {}),
                                            const Expanded(
                                              child: TextField(
                                                keyboardType:
                                                    TextInputType.text,
                                                textInputAction:
                                                    TextInputAction.search,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText:
                                                            'Search in resources...',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black)),
                                              ),
                                            ),
                                            IconButton(
                                                icon: const Icon(Icons.search,
                                                    color: MyColors.primary),
                                                onPressed: () {}),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(height: 5),
                                  ],
                                ),
                              ),*/
                            ],
                          ),
                        ),
                        floating: true,
                      ),
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: .8,
                          crossAxisSpacing: 1,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            MenuItem menuItem = menuItems[index];
                            return FxCard(
                              onTap: () {
                                menuItem.onTap();
                              },
                              paddingAll: 0,
                              margin: const EdgeInsets.only(
                                  left: 5, right: 5, top: 10),
                              color: menuItem.color,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  menuItem.Img,
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  FxText.bodyLarge(
                                    menuItem.title,
                                    color: Colors.white,
                                    textAlign: TextAlign.center,
                                    height: 1,
                                    fontWeight: 700,
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            );
                          },
                          childCount: menuItems.length,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class DropMenuItem {
  const DropMenuItem({
    required this.text,
    required this.leading,
  });

  final String text;
  final Widget leading;
}

abstract class MenuItems {
  static const List<DropMenuItem> firstItems = [profile];
  static const List<DropMenuItem> secondItems = [logout];

  static const profile = DropMenuItem(
    text: 'profile',
    leading: CircleImage(
      imageProvider:
          NetworkImage('https://www.woolha.com/media/2020/03/eevee.png'),
      backgroundColor: AppStyles.secondaryColor,
    ),
  );
  static const logout = DropMenuItem(
      text: 'Log Out',
      leading: Icon(
        Icons.logout,
        size: 24,
      ));

  static Widget buildItem(DropMenuItem item) {
    return Row(
      children: [
        item.leading,
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, DropMenuItem item) {
    switch (item) {
      case MenuItems.profile:
        AppRouter.goToUpdateProfile();
        break;
      case MenuItems.logout:
        Utils.logout();
        break;
    }
  }
}
