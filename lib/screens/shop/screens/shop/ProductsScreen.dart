import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import '../../../../controllers/MainController.dart';
import '../../../../utils/AppConfig.dart';
import '../../../../utils/CustomTheme.dart';
import '../../../../utils/SizeConfig.dart';
import '../../../../widget/widgets.dart';
import '../../models/Product.dart';
import '../../models/ProductCategory.dart';
import 'ProductScreen.dart';
import 'ProductSearchScreen.dart';

class ProductsScreen extends StatefulWidget {
  Map<String, dynamic> params;

  ProductsScreen(this.params, {Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    if (widget.params["category"].runtimeType == category.runtimeType) {
      category = widget.params["category"];
    }
    doRefresh();
  }

  ProductCategory category = ProductCategory();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          category.id > 0 ? category.category : "Products",
          color :Colors.white,
          maxLines: 2,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showBottomSheetCategoryPicker();
            },
            icon: const Icon(FeatherIcons.alignRight,
                color :Colors.white, size: 30),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const ProductSearchScreen());
            },
            icon:
                const Icon(FeatherIcons.search, color :Colors.white, size: 30),
          ),
          const SizedBox(
            width: 7,
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

  List<Product> products = [];

  Future<dynamic> myInit() async {
    mainController.getCategories();

    if (category.id > 0) {
      products = await Product.getItems(where: 'category = ${category.id}');
    } else {
      products = await Product.getItems();
    }

    return "Done";
  }

  final MainController mainController = Get.find<MainController>();

  Widget mainWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color :CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: products.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FxText(
                              'No products found \nin this category.',
                              fontWeight : 800,
                              color :Colors.black,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FxButton.text(
                                onPressed: () {
                                  showBottomSheetCategoryPicker();
                                },
                                backgroundColor:
                                    CustomTheme.primary.withAlpha(40),
                                child: FxText(
                                  'Change Filter'.toUpperCase(),
                                  color :CustomTheme.primary,
                                  fontWeight : 700,
                                ))
                          ],
                        ),
                      )
                    : CustomScrollView(
                        slivers: [
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
                                  borderColor: CustomTheme.primary,
                                  bordered: false,
                                  color :CustomTheme.primary.withAlpha(40),
                                  borderRadiusAll: 8,
                                  paddingAll: 0,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Image(
                                              image: AssetImage(
                                                  AppConfig.NO_IMAGE),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Get.to(() => ProductScreen(pro));
                                        },
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 8, right: 5),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                direction: Axis.horizontal,
                                                children: [
                                                  Expanded(
                                                    child: FxText.bodyMedium(
                                                      "UGX${pro.price_1}",
                                                      color :CustomTheme
                                                          .primaryDark,
                                                      fontWeight : 800,
                                                    ),
                                                  ),
                                                  FxCard(
                                                    marginAll: 0,
                                                    color :CustomTheme.primary,
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
              color :Colors.white,
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
                          color :Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            color :Colors.red,
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
                              category = cat;
                              setState(() {});
                              doRefresh();
                              Navigator.pop(context);
                            },
                            title: FxText.titleMedium(
                              cat.category,
                              color :CustomTheme.primary,
                              maxLines: 1,
                              fontWeight : 700,
                            ),
                            trailing: cat.id != category.id
                                ? const SizedBox()
                                : const Icon(
                                    Icons.check_circle,
                                    color :CustomTheme.primary,
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
