import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/LoggedInUserModel.dart';

import '../../../../../controllers/MainController.dart';
import '../../../../../models/RespondModel.dart';
import '../../../../../utils/CustomTheme.dart';
import '../../../../../utils/Utilities.dart';
import '../../../../../widget/widgets.dart';
import '../../../models/CartItem.dart';
import '../../../models/Product.dart';
import '../widgets.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
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
          "CHECKOUT",
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
                  return (item.id < 1) ? notLoggedInWidget() : mainWidget();
              }
            }),
      ),
    );
  }

  LoggedInUserModel item = LoggedInUserModel();

  final _fKey = GlobalKey<FormBuilderState>();
  String error_message = "";
  bool is_loading = false;

  submitOrder() async {
    item = await LoggedInUserModel.getLoggedInUser();

    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color :Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    RespondModel resp = RespondModel(await Utils.http_post('orders', {
      'items': jsonEncode(mainController.cartItems),
      'delivery': jsonEncode(item),
    }));

    if (resp.code != 1) {
      setState(() {
        error_message = "";
        is_loading = false;
      });
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      Utils.toast('Failed $error_message', color :Colors.red.shade700);
      return;
    }

    await CartItem.deleteAll();

    setState(() {
      error_message = "";
      is_loading = false;
    });
    Utils.toast('Order submitted successfully!',isLong: true);

    //Navigator.pushNamedAndRemoveUntil(context, AppConfig.FullApp, (r) => false);

      Navigator.pop(context);
    return;
  }

  Widget mainWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: _fKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "First name",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: item.name,
                              textCapitalization: TextCapitalization.words,
                              name: "first_name",
                              onChanged: (x) {
                                item.name = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Last name",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: item.name,
                              textCapitalization: TextCapitalization.words,
                              name: "last_name",
                              onChanged: (x) {
                                item.name = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Phone number",
                              ),
                              initialValue: item.phone_number_1,
                              textCapitalization: TextCapitalization.words,
                              name: "phone_number_1",
                              onChanged: (x) {
                                item.phone_number_1 = x.toString();
                              },
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Alternative Phone number",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: item.phone_number_2,
                              textCapitalization: TextCapitalization.words,
                              name: "phone_number_2",
                              onChanged: (x) {
                                item.phone_number_2 = x.toString();
                              },
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: "Address",
                              ),
                              validator: MyWidgets.my_validator_field_required(
                                  context, 'This field '),
                              initialValue: item.current_address,
                              textCapitalization: TextCapitalization.words,
                              name: "current_address",
                              onChanged: (x) {
                                item.current_address = x.toString();
                              },
                              keyboardType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.done,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                  is_loading
                      ? const CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              CustomTheme.primary),
                        )
                      : FxButton(
                          borderRadiusAll: 200,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          borderColor: CustomTheme.primary,
                          onPressed: () {
                            Get.defaultDialog(
                                middleText: "Confirm order submission",
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
                                      submitOrder();
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    child: FxText(
                                      'SUBMIT ORDER',
                                      color :Colors.white,
                                    ),
                                  )
                                ]);
                          },
                          child: FxText.titleLarge(
                            'SUBMIT ORDER',
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
    item = await LoggedInUserModel.getLoggedInUser();
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
