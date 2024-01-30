import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:omulimisa2/models/ResourceModel.dart';
import 'package:omulimisa2/screens/resources/resource_detail_screen.dart';
import 'package:omulimisa2/utils/Utilities.dart';

import "./resourceSearchScreen.dart";
import '../../core/styles.dart';
import '../../models/FarmerModel.dart';
import '../../models/ResourceCategory.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/SizeConfig.dart';
import '../../widget/widgets.dart';
class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  @override
  _ResourcesScreenState createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  @override
  void initState() {
    super.initState();
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppStyles.secondaryColor,
                      size: 30,
                    ),
                  );
                default:
                  return mainWidget();
              }
            }),
      ),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();

    setState(() {});
  }

  List<ResourceCategory> categories = [];
  List<ResourceModel> resources = [];
  List<FarmerModel> farmers = [];

  Future<dynamic> myInit() async {

    // ResourceModel resp = ResourceModel();
    //
    // farmers = await FarmerModel.get_items();

   // categories = await ResourceCategory.get_items();
    resources = await ResourceModel.get_items();
    categories = await ResourceCategory.get_items();

  }



  Widget mainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      Get.to(()=>const ResourceCategorySearchScreen());
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
                      'Search in resources...',
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

        const SizedBox(height:15),
        Expanded(
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
                        return const SizedBox(
                          height: 10,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 15, left: 10),
                          child: FxText.titleMedium(
                            'Resource Categories'.toUpperCase(),
                            fontWeight: 900,
                            color: CustomTheme.primary,
                          ),
                        );
                      },
                      childCount: 1, // 1000 list items
                    ),
                  ),
                  SliverPadding(
                    padding:const EdgeInsets.only(left: 10),
                    sliver: SliverGrid(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 6,
                        childAspectRatio: 0.78,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          ResourceCategory item = categories[index];
                          double width = Get.width / 4.5;
                          return InkWell(
                            onTap: () {
                            },
                            child: Column(
                              children: [
                                const Spacer(),
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(1000),
                                    topRight: Radius.circular(1000),
                                    bottomLeft: Radius.circular(1000),
                                    bottomRight: Radius.circular(1000),
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: width,
                                    height: width,
                                    imageUrl:
                                        "${AppConfig.STORAGE_URL}${item.thumbnail}",
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
                                    item.name.toUpperCase(),
                                    color: Colors.black,
                                    wordSpacing: 800,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: categories.length,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return const SizedBox(
                          height: 20,
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 15, top: 20),
                              child: FxText.titleMedium(
                                'Recently posted resources'.toUpperCase(),
                                fontSize: 16,
                                fontWeight: 900,
                                color: CustomTheme.primary,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5),
                              child: Divider(
                                height: 0,
                                color: CustomTheme.primary,
                              ),
                            )
                          ],
                        );
                      },
                      childCount: 1, // 1000 list items
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        ResourceModel item = resources[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() =>
                                ResourceDetailScreen(resourceModel: item));
                          },
                          child: FxContainer(
                            bordered: true,
                            borderRadiusAll: 15,
                            borderColor: CustomTheme.primary.withOpacity(.4),
                            color: CustomTheme.primary.withOpacity(.2),
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 10),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: Get.width / 2.5,
                                    height: Get.width / 3.5,
                                    imageUrl:
                                        '${AppConfig.STORAGE_URL}${item.thumbnail}',
                                    placeholder: (context, url) =>
                                        ShimmerLoadingWidget(
                                            height: Get.width / 3.5),
                                    errorWidget: (context, url, error) =>
                                        const Image(
                                      image: AssetImage(
                                        AppConfig.NO_IMAGE,
                                      ),
                                      fit: BoxFit.cover,
                                      height: 60,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Get.height / 9,
                                        child: FxText.titleMedium(
                                          item.heading,
                                          color: Colors.black,
                                          maxLines: 4,
                                          fontWeight: 700,
                                          fontSize: 18,
                                          letterSpacing: .01,
                                          height: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Flex(
                                        direction: Axis.horizontal,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FxContainer(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            color: CustomTheme.primary,
                                            child: FxText.bodySmall(
                                              item.type,
                                              color: Colors.white,
                                              fontWeight: 600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Spacer(),
                                          FxText.bodySmall(
                                            Utils.to_date_1(item.created_at),
                                            color: Colors.grey.shade700,
                                            fontWeight: 600,
                                            fontSize: 14,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: resources.length, // 1000 list items
                    ),
                  ),

                ],
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
                        itemCount: categories.length,
                        itemBuilder: (context, position) {
                          ResourceCategory cat = categories[position];
                          return ListTile(
                            onTap: () {
                            },
                            title: FxText.titleMedium(
                              cat.name,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
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





