import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/SectionResume.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/section/AccountSection.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/section/SectionDashboard.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/section/SectionSeries.dart';

import '../../../../../controllers/MainController.dart';
import '../../../../../utils/CustomTheme.dart';
import '../../../../../utils/app_theme.dart';
import '../../full_app_controller.dart';
import 'SectionFavourite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  late FullAppController controller;
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();

    theme = AppTheme.shoppingTheme;
    controller = FxControllerStore.putOrFind(FullAppController(this));
    mainController.initialized;
    mainController.init();
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];
    for (int i = 0; i < controller.navItems.length; i++) {
      tabs.add(
        Container(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Icon(
                controller.navItems[i].iconData,
                size: controller.navItems[i].title.length < 10 ? 22 : 25,
                color :(controller.currentIndex == i)
                    ? CustomTheme.accent
                    : CustomTheme.secondary,
              ),
              const SizedBox(
                height: 3,
              ),
              FxText.bodySmall(
                controller.navItems[i].title,
                fontSize: controller.navItems[i].title.length < 10 ? 12 : 8,
                color :(controller.currentIndex == i)
                    ? CustomTheme.accent
                    : CustomTheme.secondary,
              ),
            ],
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FullAppController>(
        controller: controller,
        builder: (controller) {
          return Scaffold(
            backgroundColor: CustomTheme.primary,
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: CustomTheme.primary,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.light,
                systemNavigationBarColor: CustomTheme.primary,
                systemNavigationBarIconBrightness: Brightness.light,
                systemNavigationBarContrastEnforced: true,
                systemNavigationBarDividerColor: CustomTheme.primary,
                systemStatusBarContrastEnforced: true,
              ),
              toolbarHeight: 0,
              elevation: 0,
            ),
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controller.tabController,
                            children: <Widget>[
                              const SectionDashboard(),
                              const SectionSeries(),
                              SectionResume(),
                              SectionFavourite(),
                              const AccountSection(),
                            ],
                          ),
                        ),
                        FxContainer(
                          bordered: false,
                          enableBorderRadius: false,
                          borderRadiusAll: 20,
                          padding: FxSpacing.xy(0, 5),
                          color: CustomTheme.primary,
                          child: TabBar(
                            labelPadding: EdgeInsets.zero,
                            controller: controller.tabController,
                            onTap: (index) {
                              /*if(index == 1){
                                Get.to(() => const ProductSearchScreen());
                                controller.tabController.animateTo(0);
                              }*/
                            },
                            indicator: const FxTabIndicator(
                                indicatorColor: CustomTheme.accent,
                                indicatorHeight: 10,
                                radius: 10,
                                width: 10,
                                indicatorStyle: FxTabIndicatorStyle.rectangle,
                                yOffset: -15),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: CustomTheme.accent,
                            tabs: buildTab(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
