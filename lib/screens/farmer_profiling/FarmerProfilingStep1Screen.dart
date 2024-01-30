import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/DistrictModel.dart';
import 'package:omulimisa2/models/ParishModel.dart';
import 'package:omulimisa2/models/SubcountyModel.dart';

import '../../models/FarmerGroupModel.dart';
import '../../models/FarmerOfflineModel.dart';
import '../../models/RespondModel.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';
import '../pickers/DistrictPickerScreen.dart';
import '../pickers/ParishPickerScreen.dart';
import '../pickers/SubCountyPickerScreen.dart';

class FarmerProfilingStep1Screen extends StatefulWidget {
  FarmerGroupModel group;

  FarmerProfilingStep1Screen(
    this.group, {
    Key? key,
  }) : super(key: key);

  @override
  FarmerProfilingStep1ScreenState createState() =>
      FarmerProfilingStep1ScreenState();
}

class FarmerProfilingStep1ScreenState extends State<FarmerProfilingStep1Screen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";
  FarmerOfflineModel item = FarmerOfflineModel();

  Future<bool> init_form() async {

    if (item.first_name.isNotEmpty) {
      _fKey.currentState!.patchValue(item.toJson());
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    initFuture = init_form();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          "Farmer profiling",
          fontSize: 20,
          fontWeight: 700,
          color: Colors.white,
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
                    color: Colors.white,
                  ))
        ],
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return FormBuilder(
              key: _fKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                            section_1_personal_information(
                                "PERSONAL INFORMATION"),
                            section_2_LOCATION_INFORMATION(
                                'LOCATION INFORMATION'),
                            section_2_BUSINESS_PLANNING(
                                'BUSINESS PLANNING AND RISKS'),
                            section_2_WORKFORCE('FARM WORKFORCE AND ASSETS'),
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
                      : is_loading
                          ? const Center(child: CircularProgressIndicator())
                          : FxContainer(
                              color: Colors.white,
                              borderRadiusAll: 0,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: FxButton.block(
                                  padding: const EdgeInsets.all(16),
                                  borderRadiusAll: 12,
                                  onPressed: () {
                                    submit_form();
                                  },
                                  block: false,
                                  backgroundColor: CustomTheme.primary,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FxText.titleLarge(
                                        'SUBMIT',
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
            );
          }),
    );
  }

  bool _keyboardVisible = false;

  section_2_WORKFORCE(String title) {
    return Column(
      children: [
        const SizedBox(height: 10),
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            title,
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label:
                GetStringUtils("Labor force / Number of employees").capitalize!,
          ),
          keyboardType: TextInputType.number,
          initialValue: item.labor_force,
          textCapitalization: TextCapitalization.words,
          name: "labor_force",
          onChanged: (x) {
            item.labor_force = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Equipment owned").capitalize!,
          ),
          keyboardType: TextInputType.text,
          initialValue: item.equipment_owned,
          textCapitalization: TextCapitalization.words,
          name: "equipment_owned",
          onChanged: (x) {
            item.equipment_owned = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'livestock',
          initialValue: item.livestock,
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
            label: GetStringUtils("Does a farmer have livestock?").capitalize!,
          ),
          onChanged: (x) {
            item.livestock = x.toString();
            setState(() {});
          },
        ),
        item.livestock == 'Yes'
            ? Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of cattle").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: item.cattle_count,
                    textCapitalization: TextCapitalization.words,
                    name: "cattle_count",
                    onChanged: (x) {
                      item.cattle_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of goats").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: item.goat_count,
                    textCapitalization: TextCapitalization.words,
                    name: "goat_count",
                    onChanged: (x) {
                      item.goat_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of sheep").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: item.sheep_count,
                    textCapitalization: TextCapitalization.words,
                    name: "sheep_count",
                    onChanged: (x) {
                      item.sheep_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of poultry").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: item.poultry_count,
                    textCapitalization: TextCapitalization.words,
                    name: "poultry_count",
                    onChanged: (x) {
                      item.poultry_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Number of livestock").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: item.other_livestock_count,
                    textCapitalization: TextCapitalization.words,
                    name: "other_livestock_count",
                    onChanged: (x) {
                      item.other_livestock_count = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                ],
              )
            : const SizedBox(),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Crops grown").capitalize!,
          ),
          initialValue: item.crops_grown,
          name: "crops_grown",
          onChanged: (x) {
            item.crops_grown = x.toString();
          },
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Address").capitalize!,
          ),
          initialValue: item.address,
          textCapitalization: TextCapitalization.words,
          name: "address",
          onChanged: (x) {
            item.address = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  section_2_BUSINESS_PLANNING(String title) {
    return Column(
      children: [
        const SizedBox(height: 10),
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            title,
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 15,
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
            label: GetStringUtils("Farming Production Scale").capitalize!,
          ),
          onChanged: (x) {
            item.farming_scale = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 15,
        ),
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
            label: GetStringUtils(
                    "Has this farmer bought insurance in past 6 months?")
                .capitalize!,
          ),
          onChanged: (x) {
            item.ever_bought_insurance = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 15,
        ),
        (item.ever_bought_insurance != "Yes")
            ? const SizedBox()
            : Column(
                children: [
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label:
                          GetStringUtils("Insurance company name").capitalize!,
                    ),
                    initialValue: item.insurance_company_name,
                    textCapitalization: TextCapitalization.words,
                    name: "insurance_company_name",
                    onChanged: (x) {
                      item.insurance_company_name = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Insurance cost").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: item.insurance_cost,
                    textCapitalization: TextCapitalization.words,
                    name: "insurance_cost",
                    onChanged: (x) {
                      item.insurance_cost = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label:
                          GetStringUtils("Insurance Repay Amount").capitalize!,
                    ),
                    keyboardType: TextInputType.number,
                    initialValue: item.repaid_amount,
                    textCapitalization: TextCapitalization.words,
                    name: "repaid_amount",
                    onChanged: (x) {
                      item.repaid_amount = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Covered risks").capitalize!,
                    ),
                    keyboardType: TextInputType.text,
                    initialValue: item.covered_risks,
                    textCapitalization: TextCapitalization.words,
                    name: "covered_risks",
                    onChanged: (x) {
                      item.covered_risks = x.toString();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'poverty_level',
          initialValue: item.poverty_level,
          items: [
            '',
            'Poor',
            'Vulnerable',
            'Food Secure',
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
            item.poverty_level = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'food_security_level',
          initialValue: item.food_security_level,
          items: [
            '',
            'High food security',
            'Moderate food security',
            'Low food security',
            'Very low food security',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Food security level").capitalize!,
          ),
          onChanged: (x) {
            item.food_security_level = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'has_receive_loan',
          initialValue: item.has_receive_loan,
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
                    "Has this farmer received a loan in past 6 months?")
                .capitalize!,
          ),
          onChanged: (x) {
            item.has_receive_loan = x.toString();
            setState(() {});
          },
        ),
        item.has_receive_loan != 'Yes'
            ? const SizedBox()
            : Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderDropdown(
                    dropdownColor: Colors.white,
                    isDense: true,
                    name: 'loan_usage',
                    initialValue: item.loan_usage,
                    items: [
                      '',
                      'Input',
                      'Equipment',
                      'Livestock',
                      'Personal',
                    ]
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item.toString()),
                            ))
                        .toList(),
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Main Purpose of Loan").capitalize!,
                    ),
                    onChanged: (x) {
                      item.loan_usage = x.toString();
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormBuilderTextField(
                    decoration: CustomTheme.in_3(
                      label: GetStringUtils("Loan size").capitalize!,
                    ),
                    initialValue: item.loan_size,
                    name: "loan_size",
                    onChanged: (x) {
                      item.loan_size = x.toString();
                    },
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                  ),
                ],
              ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Address").capitalize!,
          ),
          initialValue: item.address,
          textCapitalization: TextCapitalization.words,
          name: "address",
          onChanged: (x) {
            item.address = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  section_2_LOCATION_INFORMATION(String title) {
    return Column(
      children: [
        const SizedBox(height: 10),
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            title,
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("District").capitalize!,
          ),
          readOnly: true,
          onTap: () async {
            DistrictModel? x = await Get.to(() => const DistrictPickerScreen());
            if (x != null) {
              item.district_id = x.id.toString();
              item.district_text = x.name.toString();
              item.subcounty_id = "";
              item.parish_id = "";
              item.parish_text = "";
              item.subcounty_text = "";
              _fKey.currentState!.patchValue({
                "district_text": x.name.toString(),
                "subcounty_text": '',
                "parish_text": '',
              });
              setState(() {});
            }
          },
          initialValue: item.district_text,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "This field is required."),
          ]),
          textCapitalization: TextCapitalization.words,
          name: "district_text",
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Sub-county").capitalize!,
          ),
          readOnly: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "This field is required."),
          ]),
          onTap: () async {
            if (item.district_id.isEmpty) {
              Utils.toast("Please select a district first");
              return;
            }
            SubcountyModel? x = await Get.to(() => SubCountyPickerScreen(
                  int.parse(item.district_id),
                ));
            if (x != null) {
              item.subcounty_id = x.id.toString();
              item.subcounty_text = x.name.toString();
              item.parish_id = '';
              _fKey.currentState!.patchValue({
                "subcounty_text": x.name.toString(),
                "parish_text": '',
              });
              setState(() {});
            }
          },
          initialValue: item.subcounty_text,
          textCapitalization: TextCapitalization.words,
          name: "subcounty_text",
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Parish").capitalize!,
          ),
          readOnly: true,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "This field is required."),
          ]),
          onTap: () async {
            if (item.subcounty_id.isEmpty) {
              Utils.toast("Please select a subcounty first");
              return;
            }
            ParishModel? x = await Get.to(() => ParishPickerScreen(
                  int.parse(item.subcounty_id),
                ));
            if (x != null) {
              item.parish_id = x.id.toString();
              item.parish_text = x.name.toString();
              _fKey.currentState!.patchValue({
                "parish_text": x.name.toString(),
              });
              setState(() {});
            }
          },
          initialValue: item.parish_text,
          textCapitalization: TextCapitalization.words,
          name: "parish_text",
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Village").capitalize!,
          ),
          initialValue: item.village,
          textCapitalization: TextCapitalization.words,
          name: "village",
          onChanged: (x) {
            item.village = x.toString();
          },
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Village is required."),
          ]),
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Address").capitalize!,
          ),
          initialValue: item.address,
          textCapitalization: TextCapitalization.words,
          name: "address",
          onChanged: (x) {
            item.address = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("GPS - Latitude").capitalize!,
          ),
          initialValue: item.latitude,
          textCapitalization: TextCapitalization.words,
          name: "latitude",
          readOnly: true,
          onTap: () async {
            Utils.toast("Getting location...");
            Position? location = await Utils.get_device_location();
            item.latitude = location.latitude.toString();
            item.longitude = location.longitude.toString();
            _fKey.currentState!.patchValue({
              "latitude": location.latitude.toString(),
              "longitude": location.longitude.toString(),
            });
            setState(() {});
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("GPS - Longitude").capitalize!,
          ),
          initialValue: item.longitude,
          textCapitalization: TextCapitalization.words,
          name: "longitude",
          readOnly: true,
          onTap: () async {
            Utils.toast("Getting location...");
            Position? location = await Utils.get_device_location();
            item.latitude = location.latitude.toString();
            item.longitude = location.longitude.toString();
            _fKey.currentState!.patchValue({
              "latitude": location.latitude.toString(),
              "longitude": location.longitude.toString(),
            });
            setState(() {});
                    },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  section_1_personal_information(String title) {
    return Column(
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
        FxContainer(
          paddingAll: 10,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          color: CustomTheme.primary,
          child: FxText.bodyLarge(
            "Personal Information",
            fontWeight: 600,
            fontSize: 20,
            textAlign: TextAlign.center,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Farmer group").capitalize!,
          ),
          readOnly: true,
          initialValue: widget.group.name,
          textCapitalization: TextCapitalization.words,
          name: "farmer_group_text",
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Farmer group"),
          ]),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("first name").capitalize!,
          ),
          initialValue: item.first_name,
          textCapitalization: TextCapitalization.words,
          name: "first_name",
          onChanged: (x) {
            item.first_name = x.toString();
          },
          textInputAction: TextInputAction.next,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "First Name is required."),
          ]),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("last name").capitalize!,
          ),
          initialValue: item.last_name,
          textCapitalization: TextCapitalization.words,
          name: "last_name",
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "Last Name  is required."),
          ]),
          onChanged: (x) {
            item.last_name = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'gender',
          initialValue: item.gender,
          items: [
            '',
            'Male',
            'Female',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("gender").capitalize!,
          ),
          onChanged: (x) {
            item.gender = x.toString();

            setState(() {});
          },
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Gender is required."),
          ]),
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Year of birth").capitalize!,
          ),
          keyboardType: TextInputType.number,
          initialValue: item.year_of_birth,
          maxLength: 4,
          name: "year_of_birth",
          onChanged: (x) {
            item.year_of_birth = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("National ID number").capitalize!,
          ),
          initialValue: item.national_id_number,
          textCapitalization: TextCapitalization.words,
          name: "national_id_number",
          onChanged: (x) {
            item.national_text_number = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
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
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(
                errorText: "Phone number is required."),
            FormBuilderValidators.minLength(10,
                errorText: "Phone number is too short."),
            FormBuilderValidators.maxLength(10,
                errorText: "Phone number is too long."),
          ]),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'phone_type',
          initialValue: item.marital_status,
          items: [
            '',
            'Feature phone',
            'Smart phone',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Phone type").capitalize!,
          ),
          onChanged: (x) {
            item.phone_type = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Is the number provided your own phone?")
                .capitalize!,
          ),
          initialValue: item.is_your_phone,
          textCapitalization: TextCapitalization.words,
          name: "is_your_phone",
          onChanged: (x) {
            item.is_your_phone = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("education level").capitalize!,
          ),
          initialValue: item.education_level,
          textCapitalization: TextCapitalization.words,
          name: "education_level",
          onChanged: (x) {
            item.education_level = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Phone number").capitalize!,
          ),
          initialValue: item.phone_number,
          textCapitalization: TextCapitalization.words,
          name: "phone_number",
          onChanged: (x) {
            item.phone_type = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("Email Address").capitalize!,
          ),
          initialValue: item.email,
          textCapitalization: TextCapitalization.words,
          name: "email",
          onChanged: (x) {
            item.email = x.toString();
          },
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'marital_status',
          initialValue: item.marital_status,
          items: [
            '',
            'Single',
            'Married',
            'Divorced',
            'Widowed',
          ]
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          decoration: CustomTheme.in_3(
            label: GetStringUtils("marital status").capitalize!,
          ),
          onChanged: (x) {
            item.marital_status = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("family size").capitalize!,
          ),
          initialValue: item.family_size,
          textCapitalization: TextCapitalization.words,
          name: "family_size",
          onChanged: (x) {
            item.family_size = x.toString();
          },
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'is_pwd',
          initialValue: item.is_pwd,
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
            label: GetStringUtils("Is this farmer a person with disability?")
                .capitalize!,
          ),
          onChanged: (x) {
            item.is_pwd = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'is_refugee',
          initialValue: item.is_refugee,
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
            label: GetStringUtils("Is this farmer refugee?").capitalize!,
          ),
          onChanged: (x) {
            item.is_refugee = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        FormBuilderDropdown(
          dropdownColor: Colors.white,
          isDense: true,
          name: 'farm_decision_role',
          initialValue: item.farm_decision_role,
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
            label: GetStringUtils("Can the farmer make farm decisions?")
                .capitalize!,
          ),
          onChanged: (x) {
            item.farm_decision_role = x.toString();
            setState(() {});
          },
        ),
        const SizedBox(height: 15),
        FormBuilderTextField(
          decoration: CustomTheme.in_3(
            label: GetStringUtils("year of birth").capitalize!,
          ),
          keyboardType: TextInputType.number,
          initialValue: item.date_of_birth,
          textCapitalization: TextCapitalization.words,
          name: "date_of_birth",
          onChanged: (x) {
            item.date_of_birth = x.toString();
          },
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  submit_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    //show bottom sheet that ask submit now or later
    //if submit now, submit to server
    //if submit later, save to local storage

    setState(() {
      error_message = "";
      is_loading = true;
    });
    item.farmer_group_id = widget.group.id.toString();
    //await item.save();

    item.organisation_id = widget.group.id.toString();
    RespondModel resp =
        RespondModel(await Utils.http_post('farmers', item.toJson()));

    setState(() {
      error_message = resp.message;
      is_loading = false;
    });
    Utils.toast(resp.message);
    Get.back();
    return;
  }
}