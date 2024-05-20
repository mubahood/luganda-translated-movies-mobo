import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/MovieModel.dart';

import '../../../../../../controllers/MainController.dart';
import '../../../../../../utils/AppConfig.dart';
import '../../../../../../utils/CustomTheme.dart';
import '../../../../../../utils/SizeConfig.dart';
import '../../../../../../utils/app_theme.dart';
import '../../../../../../widget/widgets.dart';
import '../../../../../gardens/video_player_screen.dart';
import '../../../../models/ProductCategory.dart';
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
      backgroundColor: CustomTheme.primary,
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
    mainController.movies.shuffle();
    if (mainController.movies.length < 4) {}
    if (mainController.movies.isNotEmpty) {
      mainController.movies.shuffle();
      topMovie = mainController.movies[0];
      if (mainController.movies.length > 10) {
        mainController.movies.shuffle();
        recentMovies = mainController.movies.sublist(1, 10);
        recentMovies.shuffle();
      }
    }
    mainController.movies.sort((b, a) => a.id.compareTo(b.id));
    setState(() {});

    return;
    await mainController.getProducts();

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
                  FeatherIcons.home,
                  color: CustomTheme.accent,
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
                borderColor: CustomTheme.accent,
                margin: const EdgeInsets.only(left: 5),
                padding: const EdgeInsets.only(left: 5, top: 8, bottom: 8),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 2,
                    ),
                    const Icon(
                      FeatherIcons.search,
                      color: CustomTheme.accent,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FxText(
                      'Search Luganda translated movies...',
                      fontWeight: 400,
                      color: CustomTheme.color,
                    ),
                  ],
                ),
              )),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  showBottomSheetCategoryPicker();
                },
                child: const Icon(
                  FeatherIcons.mic,
                  color: CustomTheme.accent,
                  size: 35,
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
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 0, bottom: 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                roundedImage(topMovie.getThumbnail(), 3, 2.2),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: FxText.titleLarge(
                                          topMovie.title,
                                          fontWeight: 600,
                                          maxLines: 3,
                                          letterSpacing: .2,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          height: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RatingBar(
                                        initialRating:
                                            Random().nextDouble() * 5,
                                        itemSize: 25,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        ratingWidget: RatingWidget(
                                          full: const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          half: const Icon(
                                            Icons.star_half,
                                            color: Colors.amber,
                                          ),
                                          empty: const Icon(
                                            Icons.star_border,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Icon(
                                            FeatherIcons.eye,
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          FxText.bodySmall(
                                            "${Random().nextInt(1000)}",
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Icon(
                                            FeatherIcons.heart,
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          FxText.bodySmall(
                                            "${Random().nextInt(1000)}",
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Icon(
                                            FeatherIcons.download,
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          FxText.bodySmall(
                                            "${Random().nextInt(1000)}",
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //watch now button
                                          FxButton.outlined(
                                            onPressed: () {
                                              Get.to(() =>
                                                  VideoPlayerScreen(topMovie));
                                            },
                                            borderRadiusAll: 8,
                                            borderColor: Colors.white,
                                            block: false,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  FeatherIcons.play,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                                FxText.bodyMedium(
                                                  "Watch Now",
                                                  color: Colors.white,
                                                  fontWeight: 800,
                                                ),
                                              ],
                                            ),
                                          ),
                                          //icon button add to watchlist
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          FxButton.outlined(
                                            onPressed: () {
                                              Get.to(() =>
                                                  VideoPlayerScreen(topMovie));
                                            },
                                            borderRadiusAll: 8,
                                            borderColor: Colors.white,
                                            block: false,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: const Icon(
                                              FeatherIcons.heart,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );

/*                          return CarouselSlider(
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
                          );*/
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('Trending', () {});
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
                            items: recentMovies
                                .map(
                                  (item) => InkWell(
                                    onTap: () =>
                                        {Get.to(() => VideoPlayerScreen(item))},
                                    child: movieUi(item),
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
                          return titleWidget('Recently Uploaded', () {},
                              icon: FeatherIcons.tv);
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
                          MovieModel pro = mainController.movies[index];
                          return InkWell(
                              onTap: () {
                                Get.to(() => VideoPlayerScreen(pro));
                              },
                              child: movieUi2(pro));
                        },
                        childCount: mainController.movies.length,
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
                          'Filter by VJ',
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

  Widget movieUi2(MovieModel item) {
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
                    CustomTheme.accent.withOpacity(.9),
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
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Row(
                      children: [
                        const Icon(
                          FeatherIcons.mic,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: FxText(
                            "VJ ${item.genre}",
                            color: Colors.yellow,
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

  Widget movieUi(MovieModel item) {
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
                        CustomTheme.accent.withOpacity(.5),
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
                          height: 1.1,
                          fontWeight: 600,
                          maxLines: 2,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 1,
                        ),
                        Row(
                          children: [
                            const Icon(
                              FeatherIcons.mic,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: FxText(
                                "VJ ${item.genre}",
                                color: Colors.yellow,
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
