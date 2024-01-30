import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../controllers/MainController.dart';
import '../../../../utils/AppConfig.dart';
import '../../../../utils/CustomTheme.dart';
import '../../../../widget/widgets.dart';
import '../../models/ResourceCategory.dart';



class ResourceCategorySearchScreen extends StatefulWidget {
  const ResourceCategorySearchScreen({Key? key}) : super(key: key);

  @override
  _ResourceCategorySearchScreenState createState() => _ResourceCategorySearchScreenState();
}

class _ResourceCategorySearchScreenState extends State<ResourceCategorySearchScreen> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    doRefresh();
  }

  String keyWord = "";

  final _fKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxContainer(
          padding: const EdgeInsets.only(left: 16, right: 0),
          margin: const EdgeInsets.only(right: 15),
          child: FormBuilder(
            key: _fKey,
            child: FormBuilderTextField(
              name: 'search',
              onChanged: (value) {
                keyWord = value.toString();
                doRefresh();
              },
              autofocus: true,
              initialValue: '',
              cursorColor: CustomTheme.primary,
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                suffixIcon: TextButton(
                  onPressed: () {
                    keyWord = '';
                    _fKey.currentState!.patchValue({
                      'search': '',
                    });
                    doRefresh();
                  },
                  child: const Icon(
                    FeatherIcons.x,
                    color :CustomTheme.primary,
                  ),
                ),
                hintText: 'Search a resource category...',
                enabledBorder: InputBorder.none,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
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

  List<ResourceCategory> categories = [];

  Future<dynamic> myInit() async {
    if (keyWord.length > 1) {
      categories = await ResourceCategory.get_items(where: 'name LIKE \'%$keyWord%\'');
    } else {
      categories.clear();
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
                child: categories.isEmpty
                    ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FxText(
                        keyWord.length > 1
                            ? 'No search results for "$keyWord"'
                            : 'Type at least 3 characters\nto search.',
                        fontWeight : 800,
                        color :Colors.black,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                )
                    : CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          ResourceCategory category = categories[index];
                          return FxContainer(
                            borderColor: CustomTheme.primaryDark,
                            bordered: false,
                            onTap: () {

                            },
                            margin: const EdgeInsets.only(bottom: 15),
                            borderRadiusAll: 8,
                            paddingAll: 0,
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: Get.width / 5.6,
                                    height: Get.width / 5.6,
                                    imageUrl:
                                    "${AppConfig.MAIN_SITE_URL}/storage/${category.thumbnail}",
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
                                const SizedBox(
                                  width: 10,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top:20),
                                  child: FxText(
                                    category.name,
                                    height: 1,
                                    fontWeight : 700,
                                    maxLines: 2,
                                    color :Colors.grey.shade900,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),


                                const SizedBox(
                                  height: 2,
                                )
                              ],
                            ),
                          );
                        },
                        childCount: categories.length, // 1000 list items
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
}
