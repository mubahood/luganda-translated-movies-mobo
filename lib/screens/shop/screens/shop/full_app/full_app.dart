import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/section/AccountSection.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/section/SectionCart.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/section/SectionDashboard.dart';
import 'package:omulimisa2/screens/shop/screens/shop/full_app/section/SectionOrders.dart';

import '../../../../../controllers/MainController.dart';
import '../../../../../utils/CustomTheme.dart';
import '../../../../../utils/app_theme.dart';
import '../../full_app_controller.dart';
import '../chat/ChatsScreen.dart';
class ShopApp extends StatefulWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  _ShopAppState createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> with SingleTickerProviderStateMixin {
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
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground,
              ),
              const SizedBox(
                height: 3,
              ),
              FxText.bodySmall(
                controller.navItems[i].title,
                fontSize: controller.navItems[i].title.length < 10 ? 12 : 8,
                color :(controller.currentIndex == i)
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground,
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
                              const ChatsScreen(),
                              SectionCart(mainController),
                              SectionOrders(mainController),
                              const AccountSection(),
                            ],
                          ),
                        ),
                        FxContainer(
                          bordered: true,
                          enableBorderRadius: false,
                          border: Border(
                              top: BorderSide(
                                  color: theme.dividerColor,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          padding: FxSpacing.xy(0, 5),
                          marginAll: 0,
                          color: theme.scaffoldBackgroundColor,
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
                                indicatorColor: CustomTheme.primary,
                                indicatorHeight: 3,
                                radius: 4,
                                width: 60,
                                indicatorStyle: FxTabIndicatorStyle.rectangle,
                                yOffset: -7),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: CustomTheme.primary,
                            tabs: buildTab(),
                          ),
                        )
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
