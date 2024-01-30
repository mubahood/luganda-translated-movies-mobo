import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/screens/pickers/LocationPickerScreen.dart';

import '../../models/LocationModel.dart';
import '../../models/TrainingSessionLocalModel.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class TrainingSessionCreateBasicInformationScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  TrainingSessionCreateBasicInformationScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  TrainingSessionCreateBasicInformationScreenState createState() =>
      TrainingSessionCreateBasicInformationScreenState();
}

class TrainingSessionCreateBasicInformationScreenState
    extends State<TrainingSessionCreateBasicInformationScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";
  TrainingSessionLocalModel item = TrainingSessionLocalModel();

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
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          "Session Basic Information",
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
                    //POP
                    Navigator.pop(context, item);
                  },
                  backgroundColor: Colors.white,
                  child: FxText.bodyLarge(
                    "SAVE",
                    color: Colors.white,
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
                            const SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("session date").capitalize!,
                              ),
                              keyboardType: TextInputType.datetime,
                              inputType: InputType.date,
                              lastDate: DateTime.now(),
                              textCapitalization: TextCapitalization.words,
                              name: "session_date",
                              onChanged: (x) {
                                item.session_date = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("Start Time").capitalize!,
                              ),
                              inputType: InputType.time,
                              textCapitalization: TextCapitalization.words,
                              name: "start_date",
                              onChanged: (x) {
                                item.start_date = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("End Time").capitalize!,
                              ),
                              inputType: InputType.time,
                              textCapitalization: TextCapitalization.words,
                              name: "end_date",
                              onChanged: (x) {
                                item.end_date = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("Training Venue")
                                    .capitalize!,
                              ),
                              onTap: () async {
                                Utils.toast('Getting location...');
                                LocationModel? loc = await Get.to(
                                    () => const LocationPickerScreen());
                                if (loc != null) {
                                  item.location_id = loc.id.toString();
                                  item.location_text = loc.name.toString();
                                  _fKey.currentState!.patchValue({
                                    "location_text": item.location_text,
                                  });
                                }
                              },
                              readOnly: true,
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
                                label:
                                    GetStringUtils("gps latitude").capitalize!,
                              ),
                              readOnly: true,
                              onTap: () async {
                                Utils.toast('Getting location...');
                                Position pos =
                                    await Utils.get_device_location();
                                item.gps_latitude = pos.latitude.toString();
                                item.gps_longitude = pos.longitude.toString();
                                _fKey.currentState!.patchValue({
                                  "gps_latitude": item.gps_latitude,
                                  "gps_longitude": item.gps_longitude,
                                });
                                                            },
                              initialValue: item.gps_latitude,
                              textCapitalization: TextCapitalization.words,
                              name: "gps_latitude",
                              onChanged: (x) {
                                item.gps_latitude = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("gps longitude").capitalize!,
                              ),
                              readOnly: true,
                              onTap: () async {
                                Position pos =
                                    await Utils.get_device_location();
                                item.gps_latitude = pos.latitude.toString();
                                item.gps_longitude = pos.longitude.toString();
                                _fKey.currentState!.patchValue({
                                  "gps_latitude": item.gps_latitude,
                                  "gps_longitude": item.gps_longitude,
                                });
                                                            },
                              initialValue: item.gps_longitude,
                              textCapitalization: TextCapitalization.words,
                              name: "gps_longitude",
                              onChanged: (x) {
                                item.gps_longitude = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("details").capitalize!,
                              ),
                              initialValue: item.details,
                              textCapitalization: TextCapitalization.words,
                              name: "details",
                              minLines: 1,
                              maxLines: 3,
                              onChanged: (x) {
                                item.details = x.toString();
                              },
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FxContainer(
                      color: Colors.white,
                      borderRadiusAll: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: FxButton.block(
                          onPressed: () {
                            Navigator.pop(context, item);
                          },
                          backgroundColor: CustomTheme.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FxText.titleLarge(
                                'SAVE',
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                FeatherIcons.check,
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
}
