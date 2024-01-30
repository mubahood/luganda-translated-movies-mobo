import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/DistrictModel.dart';

import '../../controllers/MainController.dart';
import '../../models/MapLocationModel.dart';
import '../../models/ParishModel.dart';
import '../../models/SubcountyModel.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';
import '../../utils/my_colors.dart';

class AreaPickerScreen extends StatefulWidget {
  const AreaPickerScreen({Key? key}) : super(key: key);

  @override
  _AreaPickerScreenState createState() => _AreaPickerScreenState();
}

class _AreaPickerScreenState extends State<AreaPickerScreen>
    with SingleTickerProviderStateMixin {
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    mainController.initialized;
    mainController.init();
    getLocationsInbackground();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleLarge(
              "Select Location",
              fontWeight: 800,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: CustomTheme.primary,
      ),
      body: SafeArea(
        child: mainWidget(),
      ),
    );
  }

  MapLocationModel selected_location = MapLocationModel();
  bool pickerIsOpen = true;
  final _fKey = GlobalKey<FormBuilderState>();

  Widget mainWidget() {
    return FormBuilder(
      key: _fKey,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
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
                      FormBuilderTextField(
                        decoration: CustomTheme.in_3(
                          label: GetStringUtils("Select District").capitalize!,
                        ),
                        initialValue: selected_district.name,
                        textCapitalization: TextCapitalization.words,
                        name: "selected_district_name",
                        onChanged: (x) {},
                        onTap: () async {
                          districtPicker();
                        },
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required."),
                        ]),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FormBuilderTextField(
                        decoration: CustomTheme.in_3(
                          label:
                              GetStringUtils("Select Sub-County").capitalize!,
                        ),
                        initialValue: selected_sub_county.name,
                        textCapitalization: TextCapitalization.words,
                        name: "selected_sub_county_name",
                        onChanged: (x) {},
                        onTap: () async {
                          if (selected_district.name.isEmpty) {
                            Utils.toast("Please select a district first");
                            return;
                          }
                          subCountyPicker();
                        },
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required."),
                        ]),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FormBuilderTextField(
                        decoration: CustomTheme.in_3(
                          label: GetStringUtils("Select Parish").capitalize!,
                        ),
                        initialValue: selected_parish.name,
                        textCapitalization: TextCapitalization.words,
                        name: "parish_name",
                        onChanged: (x) {},
                        onTap: () async {
                          parishPicker();
                          /* if (selected_district.name.isEmpty) {
                                  Utils.toast("Please select a district first");
                                  return;
                                }

                                Utils.toast("Loading counties...");
                                parishes = await ParishModel.get_items(
                                    where:
                                        ' subcounty_id = ${selected_district.id}');
                                setState(() {});

                                parishPicker();*/
                        },
                        readOnly: true,
                        textInputAction: TextInputAction.next,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "This field is required."),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            FxContainer(
                color: Colors.white,
                borderRadiusAll: 0,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: FxButton.block(
                    padding: const EdgeInsets.all(20),
                    borderRadiusAll: 12,
                    onPressed: () {
                      if (!_fKey.currentState!.validate()) {
                        Utils.toast('Fix some errors first.',
                            color: Colors.red.shade700);
                        return;
                      }

                      Navigator.pop(context, {
                        "district": selected_district,
                        "subcounty": selected_sub_county,
                        "parish": selected_parish,
                      });
                    },
                    backgroundColor: CustomTheme.primary,
                    child: FxText.titleLarge(
                      'DONE',
                      color: Colors.white,
                    )))
          ],
        ),
      ),
    );
  }

  Future<String> getLocationName(double lat, double long) async {
    var dio = Dio();
    String name = "-";
    var resp = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${AppConfig.GOOGLE_MAP_API}');
    if (resp == null) {
      return name;
    }
    if (resp.data != null &&
        resp.data['results'] != null &&
        resp.data['results'].length > 0) {
      name = resp.data['results'][0]['formatted_address'];
    }
    return name;
  }

  bool isFirst = true;

  menuItemWidget(String title, String subTitle, String icon, Function f) {
    return InkWell(
      onTap: () {
        f();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          border: Border.all(color: CustomTheme.primary),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(244, 250, 255, 1.0),
                Color.fromRGBO(86, 176, 248, 1.0)
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.8, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  FxText.titleLarge(
                    title,
                    color: Colors.black,
                    fontWeight: 900,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FxText.bodyLarge(
                    subTitle,
                    height: 1,
                    fontWeight: 800,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Image(
              image: AssetImage(
                'assets/images/$icon',
              ),
              fit: BoxFit.cover,
              width: (MediaQuery.of(context).size.width / 3.5),
            )
          ],
        ),
      ),
    );
  }

  actionButton(String s, IconData icon, Function() param2) {
    return InkWell(
      onTap: param2,
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Icon(
            icon,
            size: 35,
            color: CustomTheme.primary,
          ),
          const SizedBox(
            height: 5,
          ),
          FxText.bodySmall(
            s,
            fontWeight: 800,
            color: CustomTheme.primary,
          ),
        ],
      ),
    );
  }

  List<DistrictModel> districts = [];
  List<ParishModel> parishes = [];
  DistrictModel selected_district = DistrictModel();
  ParishModel selected_parish = ParishModel();
  SubcountyModel selected_sub_county = SubcountyModel();

  void districtPicker() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  FxText.titleLarge(
                                    "SELECT DISTRICT".toUpperCase(),
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: 700,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    child: const Icon(
                                      FeatherIcons.x,
                                      color: MyColors.primary,
                                      size: 25,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                        itemBuilder: (context, position) {
                          DistrictModel district = districts[position];
                          return ListTile(
                            onTap: () async {
                              selected_district = district;

                              selected_parish = ParishModel();
                              selected_sub_county = SubcountyModel();

                              _fKey.currentState!.patchValue({
                                "selected_district_name":
                                    selected_district.name,
                              });

                              _fKey.currentState!.patchValue({
                                "parish_name": '',
                              });

                              _fKey.currentState!.patchValue({
                                "selected_sub_county_name": '',
                              });

                              /*sub_counties = await SubcountyModel.get_items(
                                  where:
                                      ' district_id = ${selected_district.id}');
                              setState(() {});
                              Utils.toast("${sub_counties.length}");
                              */
                              Navigator.pop(context);
                              subCountyPicker();
                            },
                            title: FxText.titleMedium(
                              district.name,
                              color: Colors.grey.shade700,
                              maxLines: 1,
                              fontWeight: 600,
                            ),
                            /* subtitle: FxText.bodySmall(
                                checkPoint.details,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),*/
                            visualDensity: VisualDensity.standard,
                            dense: false,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey.shade300),
                        itemCount: districts.length,
                      )),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future<void> parishPicker() async {
    if (selected_sub_county.name.isEmpty) {
      Utils.toast2("Please select a sub-county first");
      return;
    }
    parishes = await ParishModel.get_items(
        where: ' subcounty_id = ${selected_sub_county.id} ');
    // ignore: use_build_context_synchronously
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              padding: const EdgeInsets.only(bottom: 10),
              margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                FxText.titleLarge(
                                  "SELECT PARISH".toUpperCase(),
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: 700,
                                ),
                                const Spacer(),
                                InkWell(
                                  child: const Icon(
                                    FeatherIcons.x,
                                    color: MyColors.primary,
                                    size: 25,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListView.separated(
                      itemBuilder: (context, position) {
                        ParishModel item = parishes[position];
                        return ListTile(
                          onTap: () async {
                            selected_parish = item;

                            _fKey.currentState!.patchValue({
                              "parish_name": selected_parish.name,
                            });

                            Navigator.pop(context);
                          },
                          title: FxText.titleMedium(
                            item.name,
                            color: Colors.grey.shade700,
                            maxLines: 1,
                            fontWeight: 600,
                          ),
                          /* subtitle: FxText.bodySmall(
                              checkPoint.details,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),*/
                          visualDensity: VisualDensity.standard,
                          dense: false,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey.shade300),
                      itemCount: parishes.length,
                    )),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> subCountyPicker() async {
    if (selected_district.name.isEmpty) {
      Utils.toast2("Please select a district first");
      return;
    }
    sub_counties = await SubcountyModel.get_items(
        where: ' district_id = ${selected_district.id} ');
    setState(() {});

    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Spacer(),
                                  FxText.titleLarge(
                                    "SELECT SUB-COUNTY".toUpperCase(),
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: 700,
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    child: const Icon(
                                      FeatherIcons.x,
                                      color: MyColors.primary,
                                      size: 25,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                        itemBuilder: (context, position) {
                          SubcountyModel item = sub_counties[position];
                          return ListTile(
                            onTap: () {
                              selected_sub_county = item;
                              _fKey.currentState!.patchValue({
                                "selected_sub_county_name":
                                    selected_sub_county.name,
                              });

                              _fKey.currentState!.patchValue({
                                "parish_name": '',
                              });
                              setState(() {});
                              Navigator.pop(context);
                              parishPicker();
                            },
                            title: FxText.titleMedium(
                              item.name,
                              color: Colors.grey.shade700,
                              maxLines: 1,
                              fontWeight: 600,
                            ),
                            /* subtitle: FxText.bodySmall(
                                checkPoint.details,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),*/
                            visualDensity: VisualDensity.standard,
                            dense: false,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            Divider(height: 1, color: Colors.grey.shade300),
                        itemCount: sub_counties.length,
                      )),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  List<SubcountyModel> sub_counties = [];

  Future<void> getLocationsInbackground() async {
    districts = await DistrictModel.get_items();
    parishes = await ParishModel.get_items();
    sub_counties = await SubcountyModel.get_items();
  }
}
