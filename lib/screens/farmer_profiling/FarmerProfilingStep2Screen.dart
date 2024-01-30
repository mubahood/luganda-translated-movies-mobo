import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/FarmerOfflineModel.dart';
import '../../src/routing/routing.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class FarmerProfilingStep2Screen extends StatefulWidget {


  const FarmerProfilingStep2Screen(
    {
    Key? key,
  }) : super(key: key);

  @override
  FarmerProfilingStep2ScreenState createState() =>
      FarmerProfilingStep2ScreenState();
}

class FarmerProfilingStep2ScreenState extends State<FarmerProfilingStep2Screen>
    with SingleTickerProviderStateMixin {
  // var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";
  FarmerOfflineModel item = FarmerOfflineModel();
  Map<String, dynamic> params = Get.arguments;
  void init_form() async {
    if (params['item'] is FarmerOfflineModel) {
      item = params['item'] as FarmerOfflineModel;
    }

    // Wait for the next frame to ensure the form state is initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (item.first_name.isNotEmpty) {
        _fKey.currentState?.patchValue(item.toJson());
      }
    });
  }
  @override
  void initState() {
    super.initState();
    init_form();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          "Farmer Profiling",
            fontSize: 20,
            color: Colors.white,
            fontWeight: 700,
          ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomTheme.primary,
        actions: [
          is_loading
              ? const Padding(
                  padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                    ),
                  ),
                )
              : FxButton.text(
                  onPressed: () {
                    submit_form();
                  },
                  backgroundColor: Colors.white,
                  child: FxText.bodyLarge(
                    "SAVE",
                      color: Colors.white,
                      fontWeight: 800,
                    ))
        ],
      ),
      body:  FormBuilder(
              key: _fKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                    left: 15, top: 15, right: 15, bottom: 8),
                child: Center(
                  child: FxText.titleLarge(
                    'Address and Contacts',
                    fontWeight: 800,
                    textAlign: TextAlign.center,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
                  const Divider(
                    color: CustomTheme.primary,
                    thickness: 1,
                    height: 0,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 0,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("phone number").capitalize!,
                          ),
                          initialValue: item.phone_number,
                          textCapitalization: TextCapitalization.words,
                          name: "phone_number",
                          onChanged: (x) {
                            item.phone_number = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("address").capitalize!,
                          ),
                          initialValue: item.address,
                          textCapitalization: TextCapitalization.words,
                          name: "address",
                          onChanged: (x) {
                            item.address = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("Farmer's GPS latitude")
                                .capitalize!,
                          ),
                          initialValue: item.latitude,
                          textCapitalization: TextCapitalization.words,
                          name: "latitude",
                          onChanged: (x) {
                            item.latitude = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("Farmer's GPS longitude")
                                .capitalize!,
                          ),
                          initialValue: item.longitude,
                          textCapitalization: TextCapitalization.words,
                          name: "longitude",
                          onChanged: (x) {
                            item.longitude = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("address").capitalize!,
                          ),
                          initialValue: item.address,
                          textCapitalization: TextCapitalization.words,
                          name: "address",
                          onChanged: (x) {
                            item.address = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("village").capitalize!,
                          ),
                          initialValue: item.village,
                          textCapitalization: TextCapitalization.words,
                          name: "village",
                          onChanged: (x) {
                            item.village = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("house number").capitalize!,
                          ),
                          initialValue: item.house_number,
                          textCapitalization: TextCapitalization.words,
                          name: "house_number",
                          onChanged: (x) {
                            item.house_number = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                            const SizedBox(height: 15),
                      ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  _keyboardVisible
                      ? const SizedBox()
                      : FxContainer(
                          color: Colors.white,
                          borderRadiusAll: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FxText.titleLarge(
                                'Step 2 of 3'.toUpperCase(),
                            fontWeight: 600,
                            letterSpacing: 0.5,
                            color: Colors.grey.shade700,
                          ),
                              FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
                              block: false,
                              backgroundColor: CustomTheme.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText.titleLarge(
                                    'NEXT',
                                    color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(
                                        FeatherIcons.arrowRight,
                                        color: Colors.white,
                                      )
                                    ],
                                  )),
                            ],
                          ))
                ],
              ),
            )

    );
  }

  bool _keyboardVisible = false;

  submit_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    await item.save();
    Get.toNamed(AppRouter.farmerProfilingScreenThree, arguments:{'item':item});


    return;
  }
}
