import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../../../controllers/MainController.dart';
import '../../../../../../utils/AppConfig.dart';
import '../../../../../../utils/CustomTheme.dart';
import '../../../../../../utils/app_theme.dart';
import '../../../../../../widget/widgets.dart';
import '../../../../models/Product.dart';
import '../../../../models/ProductCategory.dart';
import '../../cart/CartScreen.dart';
import '../../widgets.dart';

class ProductScreen extends StatefulWidget {
  MainController mainController;

  ProductScreen(this.mainController, {Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: CustomTheme.primary,
        onPressed: () {
          LoggedInUserModel.getItems();
          //widget.mainController.getMyClasses();
          //MyClasses.getItems();
        },
        child: const Icon(
          FeatherIcons.plus,
          size: 25,
        ),
      ),*/
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: Text("⌛ Loading..."),
                );
              default:
                return mainWidget();
            }
          }),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();

    setState(() {});
  }

  List<Product> products = [];
  List<ProductCategory> cats = [];
  List<ProductCategory> banners = [];

  Future<dynamic> myInit() async {
    List<ProductCategory> tempCats = await ProductCategory.getItems();
    banners.clear();
    cats.clear();
    for (var e in tempCats) {
      if (e.show_in_banner == 'Yes') {
        banners.add(e);
      }
      if (e.show_in_categories == 'Yes') {
        cats.add(e);
      }
    }
    products = await Product.getItems();
    return "Done";
  }

  Widget mainWidget() {
    return Column(
      children: [
        Container(
          color :CustomTheme.primary,
          padding: const EdgeInsets.only(
            left: 10,
            right: 15,
            top: 18,
            bottom: 10,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: [
              Image(
                width: 70,
                fit: BoxFit.cover,
                image: const AssetImage(AppConfig.logo_1),
              ),
              const SizedBox(
                width: 3,
              ),
              Expanded(
                  child: FxContainer(
                color :CustomTheme.primary,
                bordered: true,
                borderRadiusAll: 8,
                borderColor: Colors.white,
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 2,
                    ),
                    const Icon(
                      FeatherIcons.search,
                      color :Colors.white,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FxText(
                      'Search...',
                      fontWeight : 400,
                      color :Colors.white,
                    ),
                    const Spacer(),
                    const Icon(
                      FeatherIcons.filter,
                      color :Colors.white,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color :CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              autoPlayInterval: const Duration(seconds: 4),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.3,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: banners
                                .map(
                                  (item) => Container(
                                    child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      height: Get.width / 2,
                                      imageUrl:
                                          "${AppConfig.MAIN_SITE_URL}/storage/${item.banner_image}",
                                      placeholder: (context, url) =>
                                          ShimmerLoadingWidget(
                                              height: Get.width / 2),
                                      errorWidget: (context, url, error) =>
                                          Image(
                                        image: const AssetImage(
                                          AppConfig.NO_IMAGE,
                                        ),
                                        fit: BoxFit.cover,
                                        height: Get.width / 2,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 15),
                            child: FxText.titleMedium(
                              'top Categories'.toUpperCase(),
                              fontWeight : 800,
                              color :CustomTheme.primary,
                            ),
                          );
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 6,
                        childAspectRatio: 0.78,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          ProductCategory item = cats[index];
                          double width = Get.width / 4.5;
                          return InkWell(
                            onTap: () {

                            },
                            child: Column(
                              children: [
                                const Spacer(),
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.contain,
                                    width: width,
                                    height: width,
                                    imageUrl:
                                        "${AppConfig.MAIN_SITE_URL}/${item.image}",
                                    placeholder: (context, url) =>
                                        ShimmerLoadingWidget(height: width),
                                    errorWidget: (context, url, error) => Image(
                                      image: const AssetImage(
                                        AppConfig.NO_IMAGE,
                                      ),
                                      fit: BoxFit.cover,
                                      width: width,
                                      height: width,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Center(
                                  child: FxText.bodyMedium(
                                    item.category.toUpperCase(),
                                    color :Colors.black,
                                    wordSpacing: 800,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: cats.length,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('Top selling items', () {});
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.76,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Product pro = products[index];
                          return FxContainer(
                            borderColor: CustomTheme.primaryDark,
                            bordered: false,
                            color :CustomTheme.primary.withAlpha(40),
                            borderRadiusAll: 8,
                            paddingAll: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: Get.width / 2.2,
                                      imageUrl:
                                          "${AppConfig.MAIN_SITE_URL}/storage/images/${pro.feature_photo}",
                                      placeholder: (context, url) =>
                                          ShimmerLoadingWidget(),
                                      errorWidget: (context, url, error) =>
                                          const Image(
                                        image: AssetImage(AppConfig.NO_IMAGE),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    //Get.to(() => ProductScreen(pro));
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 8, right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: FxText.titleSmall(
                                          "${pro.name} ",
                                          height: .9,
                                          fontWeight : 800,
                                          maxLines: 1,
                                          color :Colors.black,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: EdgeInsets.zero,
                                        child: Flex(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          direction: Axis.horizontal,
                                          children: [
                                            Expanded(
                                              child: FxText.bodyMedium(
                                                "UGX${pro.price_1}",
                                                color :CustomTheme.primaryDark,
                                                fontWeight : 800,
                                              ),
                                            ),
                                            FxCard(
                                              marginAll: 0,
                                              color :CustomTheme.primary,
                                              onTap: () {
                                                widget.mainController
                                                    .addToCart(pro);

                                                /*  Utils.toast(
                                                    "Product added to cart.");*/
                                              },
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                              child: FxText.bodySmall(
                                                'BUY NOW',
                                                fontWeight : 800,
                                                color :Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        (widget.mainController.cartItems.isEmpty)
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  Get.to(() => const CartScreen());
                },
                child: Container(
                  color :CustomTheme.primary,
                  child: Row(
                    children: [
                      FxSpacing.width(8),
                      FxText.titleSmall(
                        "You have ${widget.mainController.cartItems.length} items in cart.",
                        color :Colors.white,
                      ),
                      const Spacer(),
                      FxContainer(
                        margin:
                            const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                        color : Colors.white,
                        padding: const EdgeInsets.only(
                            left: 10, right: 5, top: 4, bottom: 2),
                        child: Row(
                          children: [
                            FxText.bodySmall(
                              "CHECKOUT",
                              fontWeight : 900,
                              color :CustomTheme.primaryDark,
                            ),
                            const Icon(
                              FeatherIcons.chevronRight,
                              color :CustomTheme.primaryDark,
                              size: 16,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
