import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';



class NavItem {
  final String title;
  final IconData iconData;

  NavItem(this.title, this.iconData);
}

class FullAppController extends FxController {
  int currentIndex = 0;

  late TabController tabController;

  late List<NavItem> navItems;

  final TickerProvider tickerProvider;

  FullAppController(this.tickerProvider) {
    navItems = [
      NavItem('MOVIES'.toUpperCase(), FeatherIcons.home),
      NavItem('Series'.toUpperCase(), Icons.movie_creation_outlined),
      NavItem('Resume'.toUpperCase(), FeatherIcons.playCircle),
      NavItem('Favorite'.toUpperCase(), FeatherIcons.heart),
      NavItem('Account'.toUpperCase(), FeatherIcons.user),
    ];

    tabController = TabController(
        length: navItems.length, vsync: tickerProvider, initialIndex: 0);
  }

  @override
  void initState() {
    super.initState();
    tabController.addListener(handleTabSelection);
    tabController.animation!.addListener(() {

      final aniValue = tabController.animation!.value;
      if (aniValue - currentIndex > 0.5) {
        currentIndex++;
        update();
      } else if (aniValue - currentIndex < -0.5) {
        currentIndex--;
        update();
      }
    });
  }

  handleTabSelection() {
    currentIndex = tabController.index;
    update();
  }

  @override
  String getTag() {
    return "shopping_manager_full_app_controller";
  }
}
