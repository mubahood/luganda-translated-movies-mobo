import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/FarmerOfflineModel.dart';
import '../../models/RespondModel.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class FarmerProfilingStep3Screen extends StatefulWidget {


  const FarmerProfilingStep3Screen(
     {
    Key? key,
  }) : super(key: key);

  @override
  FarmerProfilingStep3ScreenState createState() =>
      FarmerProfilingStep3ScreenState();
}

class FarmerProfilingStep3ScreenState extends State<FarmerProfilingStep3Screen>
    with SingleTickerProviderStateMixin {
  var initFuture;
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
            "FARMER PROFILING",
            fontSize: 20,
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
                      fontWeight: 800,
                    ))
          ],
        ),
        body: FormBuilder(
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
                    'Economic activity'.toUpperCase(),
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
                        const SizedBox(height: 10),
                        error_message.isEmpty
                            ? const SizedBox()
                            : FxContainer(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Colors.red.shade50,
                                child: Text(
                                  error_message,
                                ),
                              ),
                        FormBuilderDropdown(
                          dropdownColor: Colors.white,
                          isDense: true,
                          name: 'farming_scale',
                          initialValue: item.farming_scale,
                          items: [
                            '',
                            'Small scale',
                            'Medium scale',
                            'Large scale',
                          ]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.toString()),
                                  ))
                              .toList(),
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("Farming Production Scale")
                                .capitalize!,
                          ),
                          onChanged: (x) {
                            item.farming_scale = x.toString();
                          },
                        ),
                        const SizedBox(height: 15),
                        FormBuilderDropdown(
                          dropdownColor: Colors.white,
                          isDense: true,
                          name: 'ever_received_credit',
                          initialValue: item.ever_received_credit,
                          items: [
                            '',
                            'Yes',
                            'No',
                          ]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.toString()),
                                  ))
                              .toList(),
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils(
                                    "Has farmer ever received credit?")
                                .capitalize!,
                          ),
                          onChanged: (x) {
                            item.farming_scale = x.toString();
                          },
                        ),
                        const SizedBox(height: 15),
                        FormBuilderDropdown(
                          dropdownColor: Colors.white,
                          isDense: true,
                          name: 'has_bank_account',
                          initialValue: item.has_bank_account,
                          items: [
                            '',
                            'Yes',
                            'No',
                          ]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.toString()),
                                  ))
                              .toList(),
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils(
                                    "does a farmer have a bank account?")
                                .capitalize!,
                          ),
                          onChanged: (x) {
                            item.has_bank_account = x.toString();
                          },
                        ),
                        const SizedBox(height: 15),
                        FormBuilderDropdown(
                          dropdownColor: Colors.white,
                          isDense: true,
                          name: 'ever_bought_insurance',
                          initialValue: item.ever_bought_insurance,
                          items: [
                            '',
                            'Yes',
                            'No',
                          ]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.toString()),
                                  ))
                              .toList(),
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("Ever bought insurance?")
                                .capitalize!,
                          ),
                          onChanged: (x) {
                            item.has_bank_account = x.toString();
                          },
                        ),
                        const SizedBox(height: 15),
                        FormBuilderDropdown(
                          dropdownColor: Colors.white,
                          isDense: true,
                          name: 'poverty_level',
                          initialValue: item.poverty_level,
                          items: [
                            '',
                            'Poor',
                            'Average',
                            'Rich',
                          ]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.toString()),
                                  ))
                              .toList(),
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("Poverty level").capitalize!,
                          ),
                          onChanged: (x) {
                            item.has_bank_account = x.toString();
                          },
                        ),
                        const SizedBox(height: 15),
                        FormBuilderDropdown(
                          dropdownColor: Colors.white,
                          isDense: true,
                          name: 'food_security_level',
                          initialValue: item.food_security_level,
                          items: [
                            '',
                            'Poor',
                            'Average',
                          ]
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item.toString()),
                                  ))
                              .toList(),
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("Food security level")
                                .capitalize!,
                          ),
                          onChanged: (x) {
                            item.has_bank_account = x.toString();
                          },
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils(
                                    "Labor force / Number of employees")
                                .capitalize!,
                          ),
                          initialValue: item.labor_force,
                          textCapitalization: TextCapitalization.words,
                          name: "labor_force",
                          onChanged: (x) {
                            item.labor_force = x.toString();
                          },
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("Crops grown").capitalize!,
                          ),
                          initialValue: item.crops_grown,
                          textCapitalization: TextCapitalization.words,
                          name: "crops_grown",
                          onChanged: (x) {
                            item.crops_grown = x.toString();
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          decoration: CustomTheme.in_3(
                            label: GetStringUtils("other economic activity")
                                .capitalize!,
                          ),
                          initialValue: item.other_economic_activity,
                          textCapitalization: TextCapitalization.words,
                          name: "other_economic_activity",
                          onChanged: (x) {
                            item.other_economic_activity = x.toString();
                          },
                          textInputAction: TextInputAction.done,
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
                      child: is_loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            )
                          : FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
                              block: false,
                              backgroundColor: CustomTheme.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText.titleLarge(
                                    'REGISTER FARMER',
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    FeatherIcons.upload,
                                    color: Colors.white,
                                  )
                                ],
                              )))
            ],
          ),
        ));
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

    RespondModel resp =
        RespondModel(await Utils.http_post('farmers', item.toJson()));

    setState(() {
      is_loading = false;
    });
    if (resp.code != 1) {
      error_message = resp.message;
      Utils.toast(resp.message, color: Colors.red.shade700);
      return;
    }

    Utils.toast("Farmer registered successfully!");

    Get.offNamedUntil('homeScreen', (route) => false);

    return;
  }
}
