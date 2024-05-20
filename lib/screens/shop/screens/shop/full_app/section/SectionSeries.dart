import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/MovieModel.dart';
import 'package:omulimisa2/models/SeriesModel.dart';

import '../../../../../../controllers/MainController.dart';
import '../../../../../../utils/AppConfig.dart';
import '../../../../../../utils/CustomTheme.dart';
import '../../../../../../utils/SizeConfig.dart';
import '../../../../../../utils/Utilities.dart';
import '../../../../../../utils/app_theme.dart';
import '../../../../../../widget/widgets.dart';
import '../../../../models/ProductCategory.dart';
import '../../ProductSearchScreen.dart';
import '../../ProductsScreen.dart';
import '../../cart/CartScreen.dart';
import '../../widgets.dart';
import 'SeriesScreen.dart';

class SectionSeries extends StatefulWidget {
  const SectionSeries({Key? key}) : super(key: key);

  @override
  _SectionSeriesState createState() => _SectionSeriesState();
}

class _SectionSeriesState extends State<SectionSeries> {
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
              "Series",
              fontWeight: 900,
              color: CustomTheme.accent,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FeatherIcons.search,
              color: CustomTheme.accent,
            ),
            onPressed: () {
              Get.to(() => ProductSearchScreen());
            },
          ),
          IconButton(
            icon: const Icon(
              FeatherIcons.filter,
              color: CustomTheme.accent,
            ),
            onPressed: () {
              showBottomSheetCategoryPicker();
            },
          ),
        ],
      ),
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

  MovieModel topMovie = MovieModel();
  List<MovieModel> recentMovies = [];

  Future<dynamic> myInit() async {
    await mainController.getMovies();
    mainController.series.shuffle();

    setState(() {});

    return;
    await mainController.getProducts();

    return "Done";
  }

  Widget mainWidget() {
    return Column(
      children: [
        const Divider(
          height: 2,
          thickness: 2,
          color: CustomTheme.secondary,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('Recently added', () {});
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: false,
                              viewportFraction: .42,
                              initialPage: 1,
                              enableInfiniteScroll: false,
                              height: Get.width / 2,
                              autoPlayInterval: const Duration(seconds: 6),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: mainController.series
                                .map(
                                  (item) => InkWell(
                                    onTap: () =>
                                        {Get.to(() => SeriesScreen(item))},
                                    child: seriesUi(item),
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
                          return titleWidget('POPULAR SERIES', () {});
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          SeriesModel pro = mainController.series[index];
                          return InkWell(
                              onTap: () {
                                Get.to(() => SeriesScreen(pro));
                              },
                              child: seriesUi2(pro));
                        },
                        childCount: mainController.series.length,
                      ),
                    ),
                  ],
                ),
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

  Widget seriesUi2(SeriesModel item) {
    return Container(
        padding: const EdgeInsets.only(
          right: 5,
          left: 5,
        ),
        child: Stack(
          children: [
            roundedImage2(item.getThumbnail(), 1, 1),
            Container(
              //gradient: color with opacity
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    CustomTheme.secondary.withOpacity(.9),
                    Colors.transparent
                  ],
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 5,
                  top: 5,
                  bottom: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.bodyMedium(
                      "${item.title} ",
                      height: 1.1,
                      fontWeight: 600,
                      maxLines: 2,
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        const Icon(
                          FeatherIcons.server,
                          color: Colors.black,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: FxText(
                            item.Category,
                            color: CustomTheme.accent,
                            fontWeight: 800,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget seriesUi(SeriesModel item) {
    double h = Get.width / 2;
    return Container(
      padding: const EdgeInsets.only(
        right: 5,
        left: 5,
      ),
      child: true
          ? Stack(
              children: [
                roundedImage2(item.getThumbnail(), 2, 2),
                Container(
                  //gradient: color with opacity
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        CustomTheme.secondary.withOpacity(.5),
                        Colors.white.withOpacity(.1)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: h,
                  width: double.infinity,
                  /* color: [
                    Colors.red,
                    Colors.green,
                    Colors.blue,
                    Colors.yellow,
                    Colors.purple,
                    Colors.orange,
                    Colors.pink,
                  ][Random().nextInt(7)].withOpacity(.5),*/
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 5,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxText.bodyMedium(
                          "${item.title} ",
                          height: 1,
                          fontWeight: 800,
                          maxLines: 2,
                          color: Colors.black,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            const Icon(
                              FeatherIcons.monitor,
                              color: Colors.black,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: FxText(
                                item.Category,
                                color: CustomTheme.accent,
                                fontWeight: 800,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          : CachedNetworkImage(
              fit: BoxFit.contain,
              height: h,
              imageUrl: item.getThumbnail(),
              placeholder: (context, url) =>
                  ShimmerLoadingWidget(height: Get.width / 2),
              errorWidget: (context, url, error) => Image(
                image: const AssetImage(
                  AppConfig.NO_IMAGE,
                ),
                fit: BoxFit.cover,
                height: Get.width / 2,
              ),
            ),
    );
  }
}
