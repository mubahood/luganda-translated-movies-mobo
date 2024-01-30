import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omulimisa2/models/DynamicModel.dart';
import 'package:omulimisa2/utils/my_colors.dart';

import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';

class GardenCreateCoorditatesScreen extends StatefulWidget {
  List<DynamicModel> coordicates = [];

  GardenCreateCoorditatesScreen(this.coordicates, {super.key});

  @override
  State<GardenCreateCoorditatesScreen> createState() =>
      GardenCreateCoorditatesScreenState();
}

class GardenCreateCoorditatesScreenState
    extends State<GardenCreateCoorditatesScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(
      0.3654636,
      32.6027087,
    ),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.toast("Loading...");
    initScreen();
  }

  Future<void> initScreen() async {
    update_size();
  }

  final _formKey = GlobalKey<FormBuilderState>();
  String latitude = "";
  String longitude = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
            middleText: "Are you sure you want to cancel",
            titleStyle: const TextStyle(color: Colors.black),
            actions: <Widget>[
              FxButton.small(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                backgroundColor: Colors.red,
                child: FxText(
                  'NO',
                  color: Colors.white,
                ),
              ),
              FxButton.small(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {});
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                backgroundColor: Colors.green,
                child: FxText(
                  'YES',
                  color: Colors.white,
                ),
              ),
            ]);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FxText.titleLarge(
                "Garden Mapping Coordinates",
                color: Colors.white,
              ),
              FxText.bodySmall(
                "$size Sq. Meters",
                color: Colors.white,
              ),
            ],
          ),
          backgroundColor: MyColors.primary,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: FormBuilder(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(height: 15),
                  FormBuilderTextField(
                    name: 'latitude',
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      latitude = value.toString();
                      setState(() {});
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "This field is required.",
                      ),
                    ]),
                    decoration: CustomTheme.in_3(
                      label: "Latitude",
                    ),
                  ),
                  Container(height: 10),
                  FormBuilderTextField(
                    name: 'longitude',
                    autofocus: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      longitude = value.toString();
                      setState(() {});
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "This field is required.",
                      ),
                    ]),
                    decoration: CustomTheme.in_3(
                      label: "Latitude",
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FxButton.text(
                    onPressed: () async {
                      Utils.toast("Getting device location...");
                      Position position = await Utils.get_device_location();
                      if (position.latitude == null) {
                        Utils.toast("Failed to get device location");
                        return;
                      }
                      latitude = position.latitude.toString();
                      longitude = position.longitude.toString();
                      //patch
                      _formKey.currentState!.patchValue({
                        "latitude": latitude.toString(),
                        "longitude": longitude.toString(),
                      });
                      setState(() {});
                    },
                    child: FxText.titleMedium(
                      '📍Pick current device location',
                      fontWeight: 900,
                      color: MyColors.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  FxButton.outlined(
                    block: true,
                    borderColor: MyColors.primary,
                    onPressed: () {
                      if (latitude.isEmpty || longitude.isEmpty) {
                        Utils.toast("Please enter coordinates");
                        return;
                      }
                      if (latitude.toString().toLowerCase().contains('null')) {
                        Utils.toast("Please enter coordinates");
                        return;
                      }

                      DynamicModel model = DynamicModel();
                      model.id = (widget.coordicates.length + 1).toString();
                      model.attribute_1 = latitude;
                      model.attribute_2 = longitude;
                      widget.coordicates.add(model);

                      update_size();

                      setState(() {});
                      latitude = "";
                      longitude = "";
                      _formKey.currentState?.reset();
                      setState(() {});
                    },
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: FxText.titleLarge(
                      'ADD COORDINATES',
                      fontWeight: 900,
                      color: MyColors.primary,
                    ),
                  ),
                  Container(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.coordicates.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            widget.coordicates.removeAt(index);
                            setState(() {});
                          },
                          dense: true,
                          leading: const Icon(
                            Icons.circle,
                            color: MyColors.primary,
                            size: 26,
                          ),
                          trailing: InkWell(
                            onTap: () {
                              widget.coordicates.removeAt(index);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.red.shade700,
                              size: 26,
                            ),
                          ),
                          title: FxText.titleSmall(
                            "${widget.coordicates[index].attribute_1},${widget.coordicates[index].attribute_2}",
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: FxButton.block(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      backgroundColor: MyColors.primary,
                      borderRadiusAll: 8,
                      child: FxText.titleLarge(
                        "DONE",
                        color: Colors.white,
                        fontWeight: 600,
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  double size = 0;

  void update_size() {
    if (widget.coordicates.length < 3) {
      size = 0;
      return;
    }
    size = Utils.calculatePolygonArea(widget.coordicates);
    setState(() {});
  }
}
