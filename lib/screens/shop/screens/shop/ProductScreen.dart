import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/screens/shop/screens/shop/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../controllers/MainController.dart';
import '../../../../models/RespondModel.dart';
import '../../../../utils/AppConfig.dart';
import '../../../../utils/CustomTheme.dart';
import '../../../../utils/Utilities.dart';
import '../../../../widget/widgets.dart';
import '../../models/ChatHead.dart';
import '../../models/ImageModelLocal.dart';
import '../../models/Product.dart';
import 'cart/CartScreen.dart';
import 'chat/chat_screen.dart';


class ProductScreen extends StatefulWidget {
  Product item;

  ProductScreen(this.item, {Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState(item);
}

final MainController mainController = Get.find<MainController>();

class _ProductScreenState extends State<ProductScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;
  Product item;

  _ProductScreenState(this.item);

  @override
  void initState() {
    super.initState();
    item.getAttributes();
    init();
  }

  Future<dynamic> downloaPics() async {
    downloadedPics = await Utils.getDownloadPics();
    item.getOnlinePhotos();
    for (var pic in item.online_photos) {
      if (!downloadedPics.contains(pic.src)) {
        await Utils.downloadPhoto(pic.src);
        downloadedPics = await Utils.getDownloadPics();
      }
    }

    downloadedPics = await Utils.getDownloadPics();
  }

  List relatedProducts = [];

  Future<dynamic> init() async {
    item.getOnlinePhotos();
    setState(() {});
    downloadedPics = await Utils.getDownloadPics();
    Directory dir = await getApplicationDocumentsDirectory();
    tempPath = dir.path;
    downloaPics();
    setState(() {});

    RxList<dynamic> tempPros = mainController.products;
    tempPros.shuffle();
    if (tempPros.length > 9) {
      relatedProducts = tempPros.sublist(0, 8);
    } else {
      relatedProducts = tempPros;
    }
    setState(() {});
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
/*      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Product details",
          color :Colors.white,
          maxLines: 2,
        ),
      ),*/
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: init,
          backgroundColor: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: Colors.red,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      child: CarouselSlider(
                                        options: CarouselOptions(
                                            viewportFraction: 1,
                                            enlargeCenterPage: false,
                                            enlargeFactor: 1,
                                            enableInfiniteScroll: false,
                                            autoPlay: false,
                                            height: Get.height / 2),
                                        items: item.online_photos
                                            .map((item) => Stack(
                                          children: [
                                            FxContainer(
                                              onTap: () {
                                                openPhotos(item);
                                              },
                                              padding: EdgeInsets.zero,
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                imageUrl:
                                                "${AppConfig.MAIN_SITE_URL}/storage/images/${item.thumbnail}",
                                                placeholder: (context,
                                                    url) =>
                                                    ShimmerLoadingWidget(
                                                        height: double
                                                            .infinity),
                                                errorWidget:
                                                    (context, url, error) =>
                                                const Image(
                                                  image: AssetImage(
                                                    AppConfig.NO_IMAGE,
                                                  ),
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 15,
                                              right: 15,
                                              child: FxContainer(
                                                bordered: true,
                                                borderRadiusAll: 100,
                                                color: Colors.black
                                                    .withOpacity(.5),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 15,
                                                    vertical: 5),
                                                child: FxText.bodyLarge(
                                                  '${item.position}/${item.size}',
                                                  color: Colors.white,
                                                  fontWeight: 800,
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                            .toList(),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          FxText.titleMedium(
                                            item.name,
                                            color: Colors.black,
                                            fontWeight: 800,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: FxContainer(
                                              color: CustomTheme.primary,
                                              borderRadiusAll: 0,
                                              paddingAll: 5,
                                              child: FxText.titleMedium(
                                                "C\$ ${Utils.moneyFormat(item.price_1)} "
                                                    .toUpperCase(),
                                                color: Colors.white,
                                                textAlign: TextAlign.start,
                                                fontWeight: 900,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
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
                                Map<String, String> x = item.attributes[index];
                                return Container(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                    child: singleWidget(x['key']!, x['value']!));
                              },
                              childCount: item.attributes.length, // 1000 list items
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: FxText.titleMedium(
                                        "ITEM Description".toUpperCase(),
                                        color: Colors.black,
                                        fontWeight: 800,
                                      ),
                                    ),
                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                      child: Html(
                                        data: item.description,
                                        style: {
                                          '*': Style(
                                            color: Colors.grey.shade700,
                                          ),
                                          "strong": Style(
                                              color: CustomTheme.primary,
                                              fontSize: FontSize(18),
                                              fontWeight: FontWeight.normal),
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      thickness: 15,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: FxText.titleMedium(
                                        "YOU MAY ALSO LIKE".toUpperCase(),
                                        color: Colors.black,
                                        fontWeight: 800,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              },
                              childCount: 1, // 1000 list items
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 3),
                                    child: productUi2(relatedProducts[index]));
                              },
                              childCount: relatedProducts.length, // 1000 list items
                            ),
                          ),
                        ],
                      )),
                  const Divider(
                    color: CustomTheme.primary,
                    height: 0,
                  ),
                  mainController.userModel.id == 1
                      ? Container(
                    margin: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: FxButton.block(
                      onPressed: () {
                        Get.defaultDialog(
                            middleText:
                            "Are you sure you want to delete this product?",
                            titleStyle:
                            const TextStyle(color: Colors.black),
                            actions: <Widget>[
                              FxButton.outlined(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  Utils.toast("Deleting...");
                                  RespondModel resp = RespondModel(
                                      await Utils.http_post(
                                          'products-delete', {
                                        'id': item.id,
                                      }));
                                  if (resp.code != 1) {
                                    Utils.toast("Failed ${resp.message}");
                                    return;
                                  }
                                  mainController.getProducts();
                                  Utils.toast("Deleted: ${resp.message}");
                                  Navigator.pop(context);
                                },
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                borderColor: CustomTheme.primary,
                                child: FxText(
                                  'DELETE',
                                  color: CustomTheme.primary,
                                ),
                              ),
                              FxButton.small(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: const EdgeInsets.symmetric(
                                    vertical: 19, horizontal: 15),
                                child: FxText(
                                  'CANCEL',
                                  color: Colors.white,
                                ),
                              )
                            ]);

                        //print("Delete");
                        //Utils.toast("Chat System Coming soon...");
                        //Utils.launchPhone('+256701632257609');
                      },
                      backgroundColor: Colors.red.shade700,
                      borderRadiusAll: 10,
                      child: FxText.titleMedium(
                        'DELETE',
                        color: Colors.white,
                        fontWeight: 900,
                      ),
                    ),
                  )
                      : const SizedBox(),
                  Container(
                    color: CustomTheme.primary.withAlpha(20),
                    padding: const EdgeInsets.only(
                        bottom: 10, right: 10, left: 10, top: 10),
                    child: mainController.userModel.id.toString() ==
                        widget.item.user.toString()
                        ? Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: FxButton.block(
                            onPressed: () {
                              Utils.toast(
                                  "Edit Feature Is Coming soon...");
                            },
                            borderRadiusAll: 10,
                            child: FxText.titleMedium(
                              'EDIT',
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: FxButton.block(
                            onPressed: () {
                              Get.defaultDialog(
                                  middleText:
                                  "Are you sure you want to delete this product?",
                                  titleStyle: const TextStyle(
                                      color: Colors.black),
                                  actions: <Widget>[
                                    FxButton.outlined(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Utils.toast("Deleting...");
                                        RespondModel resp = RespondModel(
                                            await Utils.http_post(
                                                'products-delete', {
                                              'id': item.id,
                                            }));
                                        if (resp.code != 1) {
                                          Utils.toast(
                                              "Failed ${resp.message}");
                                          return;
                                        }
                                        mainController.getProducts();
                                        Utils.toast(
                                            "Deleted: ${resp.message}");
                                        Navigator.pop(context);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 15),
                                      borderColor: CustomTheme.primary,
                                      child: FxText(
                                        'DELETE',
                                        color: CustomTheme.primary,
                                      ),
                                    ),
                                    FxButton.small(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 19, horizontal: 15),
                                      child: FxText(
                                        'CANCEL',
                                        color: Colors.white,
                                      ),
                                    )
                                  ]);

                              //print("Delete");
                              //Utils.toast("Chat System Coming soon...");
                              //Utils.launchPhone('+256701632257609');
                            },
                            backgroundColor: Colors.red.shade700,
                            borderRadiusAll: 10,
                            child: FxText.titleMedium(
                              'DELETE',
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                        ),
                      ],
                    )
                        : Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: FxButton.block(
                            onPressed: () async {
                              await addToCart();
                              Get.to(() => const CartScreen());
                              //Utils.launchPhone('+256701632257609');
                            },
                            padding: const EdgeInsets.symmetric(
                              vertical: 22,
                            ),
                            borderRadiusAll: 10,
                            child: FxText.titleMedium(
                              'BUY NOW',
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: FxButton.block(
                            onPressed: () {
                              Get.to(() => ChatScreen(ChatHead(),item));
                            },
                            padding: const EdgeInsets.symmetric(
                              vertical: 22,
                            ),
                            borderRadiusAll: 10,
                            child: FxText.titleMedium(
                              'CHAT',
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FxContainer(
                    onTap: () {
                      Get.back();
                    },
                    bordered: true,
                    margin: const EdgeInsets.all(15),
                    borderRadiusAll: 100,
                    color: Colors.black.withOpacity(0.5),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  FxContainer(
                    onTap: () {
                      Utils.toast('Coming soon...');
                    },
                    bordered: true,
                    margin: const EdgeInsets.all(15),
                    borderRadiusAll: 100,
                    color: Colors.black.withOpacity(0.5),
                    child: const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addToCart() async {
    await mainController.addToCart(widget.item);
  }

  List<String> downloadedPics = [];
  String tempPath = "";

  Future<void> openPhotos(ImageModel pic) async {
    if (!downloadedPics.contains(pic.src)) {
      Utils.toast("Just a minute...");
      await Utils.downloadPhoto(pic.src);
      downloadedPics = await Utils.getDownloadPics();
    }

    if (!downloadedPics.contains(pic.src)) {
      Utils.toast(
          "Failed to download photo. Connect to internet and try again.");
      return;
    }

    ImageProvider imageProvider =
    FileImage(File("$tempPath/${pic.src.split('/').last}"));
    showImageViewer(
      context,
      imageProvider,
      backgroundColor: CustomTheme.primary,
      closeButtonColor: Colors.white,
      closeButtonTooltip: 'Close',
      doubleTapZoomable: true,
      useSafeArea: true,
      immersive: false,
      swipeDismissible: false,
    );

    return;
  }
}
