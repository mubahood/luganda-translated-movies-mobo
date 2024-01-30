import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import '../../../../../controllers/MainController.dart';
import '../../../../../utils/CustomTheme.dart';
import '../../../../../utils/Utilities.dart';
import '../../../../../widget/widgets.dart';
import '../../../models/CartItem.dart';
import '../../../models/Product.dart';
import 'CheckoutScreen.dart';
import 'cartItemWidget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "My Cart",
          color :Colors.white,
          maxLines: 2,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return myListLoaderWidget();
                default:
                  return Obx(() => mainWidget());
              }
            }),
      ),
    );
  }

  Widget mainWidget() {
    return mainController.cartItems.isEmpty
        ? Center(
            child: FxText.titleLarge("You shopping cart is empty."),
          )
        : Container(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: doRefresh,
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              CartItem m = mainController.cartItems[index];
                              return cartItemWidget(m, mainController);
                            },
                            childCount: mainController
                                .cartItems.length, // 1000 list items
                          ),
                        ),
                      ],
                    ),
                  ),
                  FxContainer(
                    borderRadiusAll: 0,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    color :CustomTheme.primary.withAlpha(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxText.bodySmall(
                              'TOTAL',
                              height: .8,
                            ),
                            Obx(() => (FxText.titleLarge(
                                  '\$ ${Utils.moneyFormat('${mainController.tot}')}',
                                  fontWeight : 800,
                                  color :Colors.black,
                                ))),
                          ],
                        ),
                        FxButton(
                            borderRadiusAll: 200,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            borderColor: CustomTheme.primary,
                            onPressed: () {
                              Get.to(() => const CheckoutScreen());
                            },
                            child: FxText.titleLarge(
                              'CHECKOUT >',
                              fontWeight : 800,
                              color :Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  late Future<dynamic> futureInit;
  MainController mainController = MainController();
  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  List<Product> items = [];

  Future<dynamic> myInit() async {
    //  await mainController.init();
    await mainController.getCartItems();
    return "Done";
  }

  menuItemWidget(String title, String subTitle, Function screen) {
    return InkWell(
      onTap: () => {screen()},
      child: Container(
        padding: const EdgeInsets.only(left: 0, bottom: 5, top: 20),
        decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: CustomTheme.primary, width: 2),
            )),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.titleLarge(
                    title,
                    color :Colors.black,
                    fontWeight : 900,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight : 600,
                    color :Colors.grey.shade700,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 35,
            )
          ],
        ),
      ),
    );
  }
}
