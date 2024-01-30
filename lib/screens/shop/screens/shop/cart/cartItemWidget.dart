import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../../controllers/MainController.dart';
import '../../../../../utils/AppConfig.dart';
import '../../../../../utils/CustomTheme.dart';
import '../../../../../utils/Utilities.dart';
import '../../../models/CartItem.dart';
import '../widgets.dart';

class cartItemWidget extends StatefulWidget {
  CartItem u;
  MainController mainController;

  cartItemWidget(this.u, this.mainController, {Key? key}) : super(key: key);

  @override
  State<cartItemWidget> createState() => _cartItemWidgetState();
}

class _cartItemWidgetState extends State<cartItemWidget> {
  @override
  Widget build(BuildContext context) {
    int price = Utils.int_parse(widget.u.product_price_1) *
        Utils.int_parse(widget.u.product_quantity);

    return Container(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImage(
              "${AppConfig.MAIN_SITE_URL}/storage/images/${widget.u.product_feature_photo}",
              4.5,
              4.5),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: FxText.titleMedium(
                        widget.u.product_name,
                        maxLines: 2,
                        fontWeight : 800,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.defaultDialog(
                                middleText:
                                    "Are you sure you need to remove this item from your cart?",
                                titleStyle: const TextStyle(color: Colors.black),
                                actions: <Widget>[
                                  FxButton.outlined(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    borderColor: CustomTheme.primary,
                                    child: FxText(
                                      'CANCEL',
                                      color :CustomTheme.primary,
                                    ),
                                  ),
                                  FxButton.small(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      doDelete(widget.u);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: FxText(
                                      'REMOVE',
                                      color :Colors.white,
                                    ),
                                  )
                                ]);
                          },
                          child: const Icon(
                            FeatherIcons.trash2,
                            color :Colors.red,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    FxContainer(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      borderRadiusAll: 0,
                      color :CustomTheme.primary,
                      child: FxText.bodyLarge(
                        "\$ ${Utils.moneyFormat("$price").toString().toUpperCase()}",
                        fontWeight : 800,
                        color :Colors.white,
                      ),
                    ),
                    const Spacer(),
                    FxContainer(
                      paddingAll: 6,
                      onTap: () {
                        int x = Utils.int_parse(widget.u.product_quantity);
                        x--;
                        if (x < 1) {
                          x = 1;
                          return;
                        }
                        widget.u.product_quantity = '$x';
                        widget.u.save();
                        widget.mainController.getCartItems();
                        setState(() {});
                      },
                      color :CustomTheme.primary.withAlpha(40),
                      borderRadiusAll: 100,
                      child: const Icon(
                        FeatherIcons.minus,
                        size: 18,
                        color :CustomTheme.primaryDark,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    FxText.bodyLarge(
                      widget.u.product_quantity,
                      maxLines: 1,
                      fontWeight : 900,
                      color :Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    FxContainer(
                      onTap: () {
                        int x = Utils.int_parse(widget.u.product_quantity);
                        x++;
                        widget.u.product_quantity = '$x';
                        widget.u.save();
                        widget.mainController.getCartItems();

                        setState(() {});
                      },
                      paddingAll: 6,
                      color :CustomTheme.primary.withAlpha(40),
                      borderRadiusAll: 100,
                      child: const Icon(
                        FeatherIcons.plus,
                        size: 18,
                        color :CustomTheme.primaryDark,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> doDelete(CartItem u) async {
    await u.delete();
    await widget.mainController.getCartItems();
    widget.mainController.update();
  }
}
