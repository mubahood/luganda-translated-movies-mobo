import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/DistrictModel.dart';
import 'package:omulimisa2/models/GardenModel.dart';
import 'package:omulimisa2/models/ParishModel.dart';
import 'package:omulimisa2/models/RespondModel.dart';
import 'package:omulimisa2/utils/Utilities.dart';
import 'package:omulimisa2/utils/my_colors.dart';

import '../../models/FarmerModel.dart';
import '../../models/SubcountyModel.dart';
import '../../utils/CustomTheme.dart';
import '../pickers/AreaPickerScreen.dart';
import '../pickers/UserPickerScreen.dart';
import 'GardenCreateBasicInformationScreen.dart';
import 'GardenCreateCoorditatorScreen.dart';
import 'GardenCreateMapScreen.dart';

class GardenCreateScreen extends StatefulWidget {
  GardenModel garden;

  GardenCreateScreen(this.garden, {super.key});

  @override
  State<GardenCreateScreen> createState() => _GardenCreateScreenState();
}

class _GardenCreateScreenState extends State<GardenCreateScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.garden.id < 1) {
      widget.garden.id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
    my_init();
  }

  my_init() async {
    if (widget.garden.id < 1) {
      widget.garden.id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
          title: "Are you sure?",
          content:
              const Text("Do you want to cancel this garden registration?"),
          textConfirm: "Yes",
          textCancel: "No",
          confirmTextColor: Colors.white,
          buttonColor: MyColors.primary,
          onConfirm: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onCancel: () {
            //Navigator.pop(context);
          },
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Garden Registration'),
          backgroundColor: MyColors.primary,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () async {
                FarmerModel? u =
                    await Get.to(() => UserPickerScreen(FarmerModel()));
                if (u != null) {
                  setState(() {
                    widget.garden.user_id = u.id.toString();
                    widget.garden.user_text = "${u.first_name} ${u.last_name}";
                  });
                }
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '1',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Garden Owner',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                widget.garden.user_text.isNotEmpty
                    ? widget.garden.user_text
                    : 'Select a garden owner',
                color: Colors.black,
              ),
              trailing: widget.garden.user_text.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            ListTile(
              onTap: () async {
                await Get.to(
                    () => GardenCreateBasicInformationScreen(widget.garden));
                setState(() {});
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '2',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Garden Information',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                'Enter garden basic information',
                color: Colors.black,
              ),
              trailing: widget.garden.name.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            ListTile(
              onTap: () async {
                dynamic data = await Get.to(() => const AreaPickerScreen());
                if (data != null) {
                  if (data.runtimeType
                      .toString()
                      .toLowerCase()
                      .contains('map')) {
                    Map<String, dynamic> m = data;
                    if (m['district'] != null &&
                        m['district'].runtimeType ==
                            DistrictModel().runtimeType) {
                      DistrictModel selectedDistrict = m['district'];
                      widget.garden.district_id =
                          selectedDistrict.id.toLowerCase();
                      widget.garden.district_text = selectedDistrict.name;
                      //do the same for subcounty
                      if (m['subcounty'] != null &&
                          m['subcounty'].runtimeType ==
                              SubcountyModel().runtimeType) {
                        SubcountyModel selectedSubCounty = m['subcounty'];
                        widget.garden.subcounty_id =
                            selectedSubCounty.id.toString();
                        widget.garden.subcounty_text = selectedSubCounty.name;
                        //do the same for parish
                        if (m['parish'] != null &&
                            m['parish'].runtimeType ==
                                ParishModel().runtimeType) {
                          ParishModel selectedParish = m['parish'];
                          widget.garden.parish_id =
                              selectedParish.id.toString();
                          widget.garden.parish_text = selectedParish.name;
                        }
                      } else {
                        widget.garden.subcounty_id = '';
                        widget.garden.subcounty_text = '';
                        widget.garden.parish_id = '';
                        widget.garden.parish_text = '';
                      }
                    }
                  }
                }
                setState(() {});
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '3',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Garden Location',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                widget.garden.parish_id.isNotEmpty
                    ? "${widget.garden.district_text}, ${widget.garden.subcounty_text}, ${widget.garden.parish_text}"
                    : 'Select garden location',
                color: Colors.black,
              ),
              trailing: widget.garden.parish_id.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            ListTile(
              onTap: () async {
                _showBottomSheet(context);
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '4',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Garden Coordinates',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                widget.garden.coordicates.isNotEmpty
                    ? '${widget.garden.size} Square Meters'
                    : 'Add Garden Coordinates',
                color: Colors.black,
              ),
              trailing: widget.garden.coordicates.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            ListTile(
              onTap: () async {

              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '5',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Garden photos',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                widget.garden.attendanceListPhotos.isNotEmpty
                    ? "${widget.garden.attendanceListPhotosUploaded.length} photos uploaded"
                    : 'Enter garden location',
                color: Colors.black,
              ),
              trailing: widget.garden.attendanceListPhotos.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            const Spacer(),
            FxContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FxButton.block(
                      backgroundColor: MyColors.primary,
                      onPressed: () {
                        submit();
                      },
                      child: FxText.titleLarge(
                        'Submit Garden'.toUpperCase(),
                        color: Colors.white,
                        fontWeight: 800,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLoading = false;

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        pick_from_map();
                      },
                      leading: const Icon(
                        FeatherIcons.map,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Get coordinates from map",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        get_coordinate_manually();
                      },
                      leading: const Icon(
                        FeatherIcons.plusCircle,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Enter coordinates manually",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> submit() async {
    //validate everything before uploading
    if (widget.garden.created_at.isEmpty) {
      Utils.toast("Garden planting date is required");
      return;
    }
    if (widget.garden.user_id.isEmpty) {
      Utils.toast("Please select a garden owner");
      return;
    }

    if (widget.garden.name.isEmpty) {
      Utils.toast("Please enter garden name");
      return;
    }
    if (widget.garden.district_id.isEmpty) {
      Utils.toast("Please select a district");
      return;
    }
    if (widget.garden.subcounty_id.isEmpty) {
      Utils.toast("Please select a subcounty");
      return;
    }
    if (widget.garden.parish_id.isEmpty) {
      Utils.toast("Please select a parish");
      return;
    }
    if (widget.garden.coordicates.length < 3) {
      Utils.toast("Please select at least 3 garden coordinates");
      return;
    }

    if (widget.garden.size.isEmpty) {
      Utils.toast("Please select at least one garden photo");
      return;
    }

    Map<String, dynamic> data = widget.garden.toJson();
    data['coordinates'] = jsonEncode(widget.garden.coordicates);

    setState(() {
      isLoading = true;
    });

    RespondModel resp =
        RespondModel(await Utils.http_post('gardens-create', data));
    setState(() {
      isLoading = false;
    });
    Utils.toast(resp.message);
    if (resp.code != 1) {
      return;
    }
    Navigator.pop(context);
  }

  void pick_from_map() async {
    await Get.to(() => GardenCreateMapScreen(widget.garden.coordicates));
    widget.garden.size =
        Utils.calculatePolygonArea(widget.garden.coordicates).toString();
    setState(() {});
  }

  void get_coordinate_manually() async {
    await Get.to(
        () => GardenCreateCoorditatesScreen(widget.garden.coordicates));
    widget.garden.size =
        Utils.calculatePolygonArea(widget.garden.coordicates).toString();
    setState(() {});
  }
}
