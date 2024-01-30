import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/FarmerModel.dart';
import '../../models/RespondModel.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class FarmerModelEditScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  FarmerModelEditScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  FarmerModelEditScreenState createState() => FarmerModelEditScreenState();
}

class FarmerModelEditScreenState extends State<FarmerModelEditScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";
  FarmerModel item = FarmerModel();

  Future<bool> init_form() async {
    if (widget.params['item'].runtimeType == item.runtimeType) {
      item = widget.params['item'];
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
          "Editing profile",
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
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return FormBuilder(
              key: _fKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
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
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("organisation text")
                                    .capitalize!,
                              ),
                              initialValue: item.organisation_text,
                              textCapitalization: TextCapitalization.words,
                              name: "organisation_text",
                              onChanged: (x) {
                                item.organisation_text = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("farmer group text")
                                    .capitalize!,
                              ),
                              initialValue: item.farmer_group_text,
                              textCapitalization: TextCapitalization.words,
                              name: "farmer_group_text",
                              onChanged: (x) {
                                item.farmer_group_text = x.toString();
                              },
                              textInputAction: TextInputAction.next,
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
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("last name").capitalize!,
                              ),
                              initialValue: item.last_name,
                              textCapitalization: TextCapitalization.words,
                              name: "last_name",
                              onChanged: (x) {
                                item.last_name = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("country text").capitalize!,
                              ),
                              initialValue: item.country_text,
                              textCapitalization: TextCapitalization.words,
                              name: "country_text",
                              onChanged: (x) {
                                item.country_text = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("language text").capitalize!,
                              ),
                              initialValue: item.language_text,
                              textCapitalization: TextCapitalization.words,
                              name: "language_text",
                              onChanged: (x) {
                                item.language_text = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("national text number")
                                    .capitalize!,
                              ),
                              initialValue: item.national_text_number,
                              textCapitalization: TextCapitalization.words,
                              name: "national_text_number",
                              onChanged: (x) {
                                item.national_text_number = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("gender").capitalize!,
                              ),
                              initialValue: item.gender,
                              textCapitalization: TextCapitalization.words,
                              name: "gender",
                              onChanged: (x) {
                                item.gender = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("education level")
                                    .capitalize!,
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
                                label:
                                    GetStringUtils("year of birth").capitalize!,
                              ),
                              initialValue: item.year_of_birth,
                              textCapitalization: TextCapitalization.words,
                              name: "year_of_birth",
                              onChanged: (x) {
                                item.year_of_birth = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("phone").capitalize!,
                              ),
                              initialValue: item.phone,
                              textCapitalization: TextCapitalization.words,
                              name: "phone",
                              onChanged: (x) {
                                item.phone = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("email").capitalize!,
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
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("is your phone").capitalize!,
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
                                label: GetStringUtils("is mm registered")
                                    .capitalize!,
                              ),
                              initialValue: item.is_mm_registered,
                              textCapitalization: TextCapitalization.words,
                              name: "is_mm_registered",
                              onChanged: (x) {
                                item.is_mm_registered = x.toString();
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
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("location text").capitalize!,
                              ),
                              initialValue: item.location_text,
                              textCapitalization: TextCapitalization.words,
                              name: "location_text",
                              onChanged: (x) {
                                item.location_text = x.toString();
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
                                label: GetStringUtils("latitude").capitalize!,
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
                                label: GetStringUtils("longitude").capitalize!,
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
                                label: GetStringUtils("password").capitalize!,
                              ),
                              initialValue: item.password,
                              textCapitalization: TextCapitalization.words,
                              name: "password",
                              onChanged: (x) {
                                item.password = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("farming scale").capitalize!,
                              ),
                              initialValue: item.farming_scale,
                              textCapitalization: TextCapitalization.words,
                              name: "farming_scale",
                              onChanged: (x) {
                                item.farming_scale = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("land holding in acres")
                                    .capitalize!,
                              ),
                              initialValue: item.land_holding_in_acres,
                              textCapitalization: TextCapitalization.words,
                              name: "land_holding_in_acres",
                              onChanged: (x) {
                                item.land_holding_in_acres = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils(
                                        "land under farming in acres")
                                    .capitalize!,
                              ),
                              initialValue: item.land_under_farming_in_acres,
                              textCapitalization: TextCapitalization.words,
                              name: "land_under_farming_in_acres",
                              onChanged: (x) {
                                item.land_under_farming_in_acres = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("ever bought insurance")
                                    .capitalize!,
                              ),
                              initialValue: item.ever_bought_insurance,
                              textCapitalization: TextCapitalization.words,
                              name: "ever_bought_insurance",
                              onChanged: (x) {
                                item.ever_bought_insurance = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("ever received credit")
                                    .capitalize!,
                              ),
                              initialValue: item.ever_received_credit,
                              textCapitalization: TextCapitalization.words,
                              name: "ever_received_credit",
                              onChanged: (x) {
                                item.ever_received_credit = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("status").capitalize!,
                              ),
                              initialValue: item.status,
                              textCapitalization: TextCapitalization.words,
                              name: "status",
                              onChanged: (x) {
                                item.status = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("created by user text")
                                    .capitalize!,
                              ),
                              initialValue: item.created_by_user_text,
                              textCapitalization: TextCapitalization.words,
                              name: "created_by_user_text",
                              onChanged: (x) {
                                item.created_by_user_text = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("created by agent text")
                                    .capitalize!,
                              ),
                              initialValue: item.created_by_agent_text,
                              textCapitalization: TextCapitalization.words,
                              name: "created_by_agent_text",
                              onChanged: (x) {
                                item.created_by_agent_text = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("agent text").capitalize!,
                              ),
                              initialValue: item.agent_text,
                              textCapitalization: TextCapitalization.words,
                              name: "agent_text",
                              onChanged: (x) {
                                item.agent_text = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("created at").capitalize!,
                              ),
                              initialValue: item.created_at,
                              textCapitalization: TextCapitalization.words,
                              name: "created_at",
                              onChanged: (x) {
                                item.created_at = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("updated at").capitalize!,
                              ),
                              initialValue: item.updated_at,
                              textCapitalization: TextCapitalization.words,
                              name: "updated_at",
                              onChanged: (x) {
                                item.updated_at = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("poverty level").capitalize!,
                              ),
                              initialValue: item.poverty_level,
                              textCapitalization: TextCapitalization.words,
                              name: "poverty_level",
                              onChanged: (x) {
                                item.poverty_level = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("food security level")
                                    .capitalize!,
                              ),
                              initialValue: item.food_security_level,
                              textCapitalization: TextCapitalization.words,
                              name: "food_security_level",
                              onChanged: (x) {
                                item.food_security_level = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("marital status")
                                    .capitalize!,
                              ),
                              initialValue: item.marital_status,
                              textCapitalization: TextCapitalization.words,
                              name: "marital_status",
                              onChanged: (x) {
                                item.marital_status = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("family size").capitalize!,
                              ),
                              initialValue: item.family_size,
                              textCapitalization: TextCapitalization.words,
                              name: "family_size",
                              onChanged: (x) {
                                item.family_size = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("farm decision role")
                                    .capitalize!,
                              ),
                              initialValue: item.farm_decision_role,
                              textCapitalization: TextCapitalization.words,
                              name: "farm_decision_role",
                              onChanged: (x) {
                                item.farm_decision_role = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("is pwd").capitalize!,
                              ),
                              initialValue: item.is_pwd,
                              textCapitalization: TextCapitalization.words,
                              name: "is_pwd",
                              onChanged: (x) {
                                item.is_pwd = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("is refugee").capitalize!,
                              ),
                              initialValue: item.is_refugee,
                              textCapitalization: TextCapitalization.words,
                              name: "is_refugee",
                              onChanged: (x) {
                                item.is_refugee = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("date of birth").capitalize!,
                              ),
                              initialValue: item.date_of_birth,
                              textCapitalization: TextCapitalization.words,
                              name: "date_of_birth",
                              onChanged: (x) {
                                item.date_of_birth = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("age group").capitalize!,
                              ),
                              initialValue: item.age_group,
                              textCapitalization: TextCapitalization.words,
                              name: "age_group",
                              onChanged: (x) {
                                item.age_group = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("language preference")
                                    .capitalize!,
                              ),
                              initialValue: item.language_preference,
                              textCapitalization: TextCapitalization.words,
                              name: "language_preference",
                              onChanged: (x) {
                                item.language_preference = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("phone type").capitalize!,
                              ),
                              initialValue: item.phone_type,
                              textCapitalization: TextCapitalization.words,
                              name: "phone_type",
                              onChanged: (x) {
                                item.phone_type = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("home gps latitude")
                                    .capitalize!,
                              ),
                              initialValue: item.home_gps_latitude,
                              textCapitalization: TextCapitalization.words,
                              name: "home_gps_latitude",
                              onChanged: (x) {
                                item.home_gps_latitude = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("home gps longitude")
                                    .capitalize!,
                              ),
                              initialValue: item.home_gps_longitude,
                              textCapitalization: TextCapitalization.words,
                              name: "home_gps_longitude",
                              onChanged: (x) {
                                item.home_gps_longitude = x.toString();
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
                                label: GetStringUtils("street").capitalize!,
                              ),
                              initialValue: item.street,
                              textCapitalization: TextCapitalization.words,
                              name: "street",
                              onChanged: (x) {
                                item.street = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("house number").capitalize!,
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
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("land registration numbers")
                                        .capitalize!,
                              ),
                              initialValue: item.land_registration_numbers,
                              textCapitalization: TextCapitalization.words,
                              name: "land_registration_numbers",
                              onChanged: (x) {
                                item.land_registration_numbers = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("labor force").capitalize!,
                              ),
                              initialValue: item.labor_force,
                              textCapitalization: TextCapitalization.words,
                              name: "labor_force",
                              onChanged: (x) {
                                item.labor_force = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("equipment owned")
                                    .capitalize!,
                              ),
                              initialValue: item.equipment_owned,
                              textCapitalization: TextCapitalization.words,
                              name: "equipment_owned",
                              onChanged: (x) {
                                item.equipment_owned = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("livestock").capitalize!,
                              ),
                              initialValue: item.livestock,
                              textCapitalization: TextCapitalization.words,
                              name: "livestock",
                              onChanged: (x) {
                                item.livestock = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("crops grown").capitalize!,
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
                                label: GetStringUtils("has bank account")
                                    .capitalize!,
                              ),
                              initialValue: item.has_bank_account,
                              textCapitalization: TextCapitalization.words,
                              name: "has_bank_account",
                              onChanged: (x) {
                                item.has_bank_account = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("has mobile money account")
                                        .capitalize!,
                              ),
                              initialValue: item.has_mobile_money_account,
                              textCapitalization: TextCapitalization.words,
                              name: "has_mobile_money_account",
                              onChanged: (x) {
                                item.has_mobile_money_account = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("payments or transfers")
                                    .capitalize!,
                              ),
                              initialValue: item.payments_or_transfers,
                              textCapitalization: TextCapitalization.words,
                              name: "payments_or_transfers",
                              onChanged: (x) {
                                item.payments_or_transfers = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("financial service provider")
                                        .capitalize!,
                              ),
                              initialValue: item.financial_service_provider,
                              textCapitalization: TextCapitalization.words,
                              name: "financial_service_provider",
                              onChanged: (x) {
                                item.financial_service_provider = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("has credit").capitalize!,
                              ),
                              initialValue: item.has_credit,
                              textCapitalization: TextCapitalization.words,
                              name: "has_credit",
                              onChanged: (x) {
                                item.has_credit = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("loan size").capitalize!,
                              ),
                              initialValue: item.loan_size,
                              textCapitalization: TextCapitalization.words,
                              name: "loan_size",
                              onChanged: (x) {
                                item.loan_size = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("loan usage").capitalize!,
                              ),
                              initialValue: item.loan_usage,
                              textCapitalization: TextCapitalization.words,
                              name: "loan_usage",
                              onChanged: (x) {
                                item.loan_usage = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("farm business plan")
                                    .capitalize!,
                              ),
                              initialValue: item.farm_business_plan,
                              textCapitalization: TextCapitalization.words,
                              name: "farm_business_plan",
                              onChanged: (x) {
                                item.farm_business_plan = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("covered risks").capitalize!,
                              ),
                              initialValue: item.covered_risks,
                              textCapitalization: TextCapitalization.words,
                              name: "covered_risks",
                              onChanged: (x) {
                                item.covered_risks = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("insurance company name")
                                    .capitalize!,
                              ),
                              initialValue: item.insurance_company_name,
                              textCapitalization: TextCapitalization.words,
                              name: "insurance_company_name",
                              onChanged: (x) {
                                item.insurance_company_name = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("insurance cost")
                                    .capitalize!,
                              ),
                              initialValue: item.insurance_cost,
                              textCapitalization: TextCapitalization.words,
                              name: "insurance_cost",
                              onChanged: (x) {
                                item.insurance_cost = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("repaid amount").capitalize!,
                              ),
                              initialValue: item.repaid_amount,
                              textCapitalization: TextCapitalization.words,
                              name: "repaid_amount",
                              onChanged: (x) {
                                item.repaid_amount = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("photo").capitalize!,
                              ),
                              initialValue: item.photo,
                              textCapitalization: TextCapitalization.words,
                              name: "photo",
                              onChanged: (x) {
                                item.photo = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _keyboardVisible
                      ? const SizedBox()
                      : FxContainer(
                          color: Colors.white,
                          borderRadiusAll: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
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
                              )))
                ],
              ),
            );
          }),
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

    Utils.toast('Updating...', color: Colors.green.shade700);

    RespondModel resp = RespondModel(
        await Utils.http_post(FarmerModel.end_point, item.toJson()));

    setState(() {
      error_message = "";
      is_loading = false;
    });

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      Utils.toast('Failed', color: Colors.red.shade700);
      return;
    }

    Utils.toast('Successfully!');

    Navigator.pop(context);
    return;
  }
}
