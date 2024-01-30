import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../../../controllers/MainController.dart';
import '../../../../../../utils/AppConfig.dart';
import '../../../../../../utils/CustomTheme.dart';
import '../../../../../../utils/SizeConfig.dart';
import '../../../../../../utils/app_theme.dart';
import '../../../../../../widget/widgets.dart';
import '../../../../models/Product.dart';
import '../../../../models/ProductCategory.dart';
import '../../ProductScreen.dart';
import '../../ProductSearchScreen.dart';
import '../../ProductsScreen.dart';
import '../../cart/CartScreen.dart';
import '../../widgets.dart';
class SectionDashboard extends StatefulWidget {
  const SectionDashboard({Key? key}) : super(key: key);

  @override
  _SectionDashboardState createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboard> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
  doRefresh();
  }

  final MainController mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

  List<ProductCategory> cats = [];
  List<ProductCategory> banners = [];

  Future<dynamic> myInit() async {
    await mainController.getCategories();

    cats.clear();
    banners.clear();
    await mainController.getProducts();

    for (var e in mainController.categories) {
      if (e.show_in_banner.toString().toLowerCase() == 'yes') {
        banners.add(e);
      }
      if (e.show_in_categories == 'Yes') {
        cats.add(e);
      }
    }

    return "Done";
  }

  Widget mainWidget() {
    return Column(
      children: [
        Container(
          color: CustomTheme.primary,
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
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  FeatherIcons.arrowLeft,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: FxContainer(
                onTap: () {
                  Get.to(() => const ProductSearchScreen());
                },
                color: CustomTheme.primary,
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
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FxText(
                      'Search...',
                      fontWeight: 400,
                      color: Colors.white,
                    ),
                  ],
                ),
              )),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  showBottomSheetCategoryPicker();
                },
                child: const Icon(
                  FeatherIcons.filter,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        ),

        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: Obx(() => CustomScrollView(
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
                                  autoPlayInterval: const Duration(seconds: 6),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.3,
                                  scrollDirection: Axis.horizontal,
                                ),
                            items: banners
                                .map(
                                      (item) => InkWell(
                                        onTap: () => {
                                          Get.to(() => ProductsScreen(
                                              {'category': item}))
                                        },
                                        child: CachedNetworkImage(
                                          fit: BoxFit.contain,
                                          height: Get.width / 2,
                                          imageUrl:
                                              "${AppConfig.MAIN_SITE_URL}/${item.banner_image}",
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
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 15),
                                child: FxText.titleMedium(
                                  'top Categories'.toUpperCase(),
                                  fontWeight: 900,
                                  color: CustomTheme.primary,
                                ),
                              );
                            },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  Get.to(
                                      () => ProductsScreen({'category': item}));
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
                                        errorWidget: (context, url, error) =>
                                            Image(
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
                                        color: Colors.black,
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
                              Product pro = mainController.products[index];
                              return FxContainer(
                                borderColor: CustomTheme.primaryDark,
                                bordered: false,
                                color: CustomTheme.primary.withAlpha(40),
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
                                            image:
                                                AssetImage(AppConfig.NO_IMAGE),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                  ),
                                  onTap: () {
                                    Get.to(() => ProductScreen(pro));
                                  },
                                ),
                                Container(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8),
                                            child: FxText.titleSmall(
                                              "${pro.name} ",
                                              height: .9,
                                              fontWeight: 800,
                                              maxLines: 1,
                                              color: Colors.black,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              direction: Axis.horizontal,
                                              children: [
                                                Expanded(
                                                  child: FxText.bodyMedium(
                                                    "UGX${pro.price_1}",
                                                    color:
                                                        CustomTheme.primaryDark,
                                                    fontWeight: 800,
                                                  ),
                                                ),
                                                FxCard(
                                                  marginAll: 0,
                                                  color: CustomTheme.primary,
                                                  onTap: () {
                                                    mainController
                                                        .addToCart(pro);

                                                    /*  Utils.toast(
                                                    "Product added to cart.");*/
                                                  },
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  child: FxText.bodySmall(
                                                    'BUY NOW',
                                                    fontWeight: 800,
                                                    color: Colors.white,
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
                            childCount: mainController.products.length,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
        (mainController.cartItems.isEmpty)
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  Get.to(() => const CartScreen());
                },
                child: Container(
                  color: CustomTheme.primary,
                  child: Row(
                    children: [
                      FxSpacing.width(8),
                      FxText.titleSmall(
                        "You have ${mainController.cartItems.length} items in cart.",
                        color: Colors.white,
                      ),
                      const Spacer(),
                      FxContainer(
                        margin:
                            const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                        color: Colors.grey.shade200,
                        padding: const EdgeInsets.only(
                            left: 10, right: 5, top: 4, bottom: 2),
                        child: Row(
                          children: [
                            FxText.bodySmall(
                              "CHECKOUT",
                              fontWeight: 900,
                              color: CustomTheme.primaryDark,
                            ),
                            const Icon(
                              FeatherIcons.chevronRight,
                              color: CustomTheme.primaryDark,
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

  void showBottomSheetCategoryPicker() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size16),
                topRight: Radius.circular(MySize.size16),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText.titleMedium(
                          'Filter by categories',
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: mainController.categories.length,
                        itemBuilder: (context, position) {
                          ProductCategory cat =
                              mainController.categories[position];
                          return ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Get.to(() => ProductsScreen({'category': cat}));
                            },
                            title: FxText.titleMedium(
                              cat.category,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
                            ),
                            trailing: true
                                ? const SizedBox()
                                : const Icon(
                                    Icons.check_circle,
                                    color: CustomTheme.primary,
                                    size: 30,
                                  ),
                            visualDensity: VisualDensity.compact,
                            dense: true,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
