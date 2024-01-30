import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../../../controllers/MainController.dart';
import '../../../../../../utils/CustomTheme.dart';
import '../../../../../../utils/Utilities.dart';
import '../../ProductCreateScreen.dart';
import '../../widgets.dart';
import '../full_app.dart';

class AccountSection extends StatefulWidget {
  const AccountSection({Key? key}) : super(key: key);

  @override
  _AccountSectionState createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  late CustomTheme theme;

  @override
  void initState() {
    super.initState();
    theme = CustomTheme();
    myInit();
  }

  final MainController mainController = Get.find<MainController>();

  myInit() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Utils.overlay(),
        elevation: .5,
        automaticallyImplyLeading: false,
        title: FxText.titleLarge(
          "Account ",
          fontWeight : 900,
        ),
      ),
      body: (mainController.userModel.id < 1)
          ? notLoggedInWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      FeatherIcons.user,
                      color :CustomTheme.primary,
                    ),
                    title: FxText.bodyLarge(
                      "My Profile",
                    ),
                    onTap: () {},
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color :CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Change Password",
                    ),
                    onTap: () {},
                    leading: const Icon(
                      FeatherIcons.key,
                      color :CustomTheme.primary,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color :CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Sell now",
                    ),
                    leading: const Icon(
                      FeatherIcons.tag,
                      color :CustomTheme.primary,
                    ),
                    onTap: () {
                      Get.to(()=> const ProductCreateScreen());
                    },
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color :CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "How it works",
                    ),
                    leading: const Icon(
                      FeatherIcons.helpCircle,
                      color :CustomTheme.primary,
                    ),
                    onTap: () {},
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color :CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Contact Us",
                    ),
                    leading: const Icon(
                      FeatherIcons.phone,
                      color :CustomTheme.primary,
                    ),
                    onTap: () {},
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color :CustomTheme.primary,
                    ),
                  ),
                  ListTile(
                    title: FxText.bodyLarge(
                      "Logout",
                    ),
                    leading: const Icon(
                      FeatherIcons.logOut,
                      color :CustomTheme.primary,
                    ),
                    onTap: () {
                      Get.defaultDialog(
                          middleText: "Are you sure you want to logout?",
                          titleStyle: const TextStyle(color: Colors.black),
                          actions: <Widget>[
                            FxButton.outlined(
                              onPressed: () {
                                Navigator.pop(context);
                                do_logout();
                              },
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              borderColor: CustomTheme.primary,
                              child: FxText(
                                'LOGOUT',
                                color :CustomTheme.primary,
                              ),
                            ),
                            FxButton.small(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: FxText(
                                'CANCEL',
                                color :Colors.white,
                              ),
                            )
                          ]);
                    },
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color :CustomTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> do_logout() async {
    Utils.logout();
    Utils.toast("Logged you out!");
    Get.to(() => const ShopApp());
    //Navigator.pushNamedAndRemoveUntil(context, AppConfig.FullApp, (r) => false);
  }
}
