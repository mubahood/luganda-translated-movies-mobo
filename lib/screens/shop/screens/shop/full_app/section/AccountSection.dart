import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../../../controllers/MainController.dart';
import '../../../../../../utils/CustomTheme.dart';
import '../../../../../../utils/Utilities.dart';
import '../../ProductSearchScreen.dart';
import '../../account/AccountEdit.dart';
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

  myInit() async {
    mainController.getLoggedInUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.overlay(),
        elevation: .5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const FxContainer(
              width: 12,
              color: CustomTheme.secondary,
              height: 25,
            ),
            const SizedBox(
              width: 10,
            ),
            FxText.titleLarge(
              "My Account",
              fontWeight: 900,
              color: CustomTheme.accent,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FeatherIcons.user,
              color: CustomTheme.accent,
            ),
            onPressed: () {
              Get.to(() => const ProductSearchScreen());
            },
          ),
          IconButton(
            icon: const Icon(
              FeatherIcons.helpCircle,
              color: CustomTheme.accent,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(
            height: .5,
            color: CustomTheme.accent,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      FeatherIcons.user,
                      color: CustomTheme.secondary,
                      size: 35,
                    ),
                    title: FxText.bodyLarge(
                      "My Profile",
                      fontWeight: 600,
                      color: CustomTheme.color,
                    ),
                    onTap: () {
                      Get.to(() => const AccountEdit());
                    },
                    subtitle: FxText.bodySmall(
                      "View and edit your profile",
                      color: CustomTheme.color3,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.secondary,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FeatherIcons.key,
                      color: CustomTheme.secondary,
                      size: 35,
                    ),
                    title: FxText.bodyLarge(
                      "Change Password",
                      fontWeight: 600,
                      color: CustomTheme.color,
                    ),
                    onTap: () {
                      Utils.toast("Coming soon!");
                      return;
                    },
                    subtitle: FxText.bodySmall(
                      "Update your password",
                      color: CustomTheme.color3,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.secondary,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FeatherIcons.monitor,
                      color: CustomTheme.secondary,
                      size: 35,
                    ),
                    title: FxText.bodyLarge(
                      "My Subscription",
                      fontWeight: 600,
                      color: CustomTheme.color,
                    ),
                    onTap: () {
                      Utils.toast("Coming soon!");
                      return;
                    },
                    subtitle: FxText.bodySmall(
                      "Manage your subscription",
                      color: CustomTheme.color3,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.secondary,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FeatherIcons.info,
                      color: CustomTheme.secondary,
                      size: 35,
                    ),
                    title: FxText.bodyLarge(
                      "How it works",
                      fontWeight: 600,
                      color: CustomTheme.color,
                    ),
                    onTap: () {
                      Utils.toast("Coming soon!");
                      return;
                    },
                    subtitle: FxText.bodySmall(
                      "Learn how the app works",
                      color: CustomTheme.color3,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.secondary,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      FeatherIcons.mail,
                      color: CustomTheme.secondary,
                      size: 35,
                    ),
                    title: FxText.bodyLarge(
                      "Contact Us",
                      fontWeight: 600,
                      color: CustomTheme.color,
                    ),
                    onTap: () {
                      Utils.toast("Coming soon!");
                      return;
                    },
                    subtitle: FxText.bodySmall(
                      "Get in touch with us",
                      color: CustomTheme.color3,
                    ),
                    trailing: const Icon(
                      FeatherIcons.chevronRight,
                      color: CustomTheme.secondary,
                      size: 30,
                    ),
                  ),
                  ListTile(
                    trailing: const Icon(
                      FeatherIcons.logOut,
                      color: CustomTheme.accent,
                      size: 35,
                    ),
                    title: FxText.bodyLarge(
                      "Logout",
                      fontWeight: 600,
                      color: CustomTheme.color,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      do_logout();
                    },
                    subtitle: FxText.bodySmall(
                      "Sign out of your account",
                      color: CustomTheme.color3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> do_logout() async {
    Utils.logout();
    Utils.toast("Logged you out!");
    Get.to(() => const HomeScreen());
    //Navigator.pushNamedAndRemoveUntil(context, AppConfig.FullApp, (r) => false);
  }
}
