import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/MainController.dart';
import '../models/MapLocationModel.dart';
import '../utils/AppConfig.dart';
import '../utils/CustomTheme.dart';
import '../utils/Utilities.dart';
import '../utils/my_colors.dart';

class MapPickerScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  MapPickerScreen(this.params, {super.key});

  @override
  State<MapPickerScreen> createState() => MapPickerScreenState();
}

class MapPickerScreenState extends State<MapPickerScreen> {
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
    myFocusNode = FocusNode();

    initScreen();
  }

  BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;

  Future<void> initScreen() async {}

  late final GoogleMapController controller;

  bool mapReady = false;
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> mapCompleted() async {
    controller = await _controller.future;
    mapReady = true;
    _init_content();
  }

  moveToLatLong(String lat, String long, {double zoom = 0}) async {
    if (zoom != 0) {
      CameraPosition pos = CameraPosition(
          target: LatLng(double.parse(lat), double.parse(long)),
          tilt: 0,
          zoom: 14);
      await controller.animateCamera(CameraUpdate.newCameraPosition(pos));
    } else {
      zoom = await controller.getZoomLevel();
      CameraPosition pos = CameraPosition(
          target: LatLng(double.parse(lat), double.parse(long)), zoom: zoom);
      await controller.animateCamera(CameraUpdate.newCameraPosition(pos));
    }
  }

  MapType mapType = MapType.normal;
  late FocusNode myFocusNode;
  final MainController mainController = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: Get.height,
              padding: const EdgeInsets.only(bottom: 0),
              width: Get.width,
              child: GoogleMap(
                mapType: mapType,
                trafficEnabled: false,
                onTap: (LatLng latLng) {
                  searchIsHidden = true;
                  moveToLatLong(
                    latLng.latitude.toString(),
                    latLng.longitude.toString(),
                  );
                  addMarker(latLng.latitude.toString(),
                      latLng.longitude.toString(), 'ME',
                      title: 'Selected Location'.toString(),
                      sub_title: '${latLng.latitude}, '
                          '${latLng.longitude}');
                  setState(() {});
                },
                initialCameraPosition: _kGooglePlex,
                markers: markers,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                //poly-lines
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  mapCompleted();
                },
              ),
            ),
            Positioned(
              left: 15,
              top: 15,
              child: FxCard(
                height: 50,
                width: Get.width - 30,
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 0,
                ),
                borderRadiusAll: 50,
                color: Colors.white,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    FxContainer(
                      paddingAll: 10,
                      onTap: () {
                        Get.back();
                      },
                      color: Colors.white,
                      borderRadiusAll: 100,
                      child: const Icon(FeatherIcons.arrowLeft, size: 25),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          searchIsHidden = false;
                          try {
                            myFocusNode.requestFocus();
                          } catch (e) {}

                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.only(top: 8, bottom: 5),
                          child: FxText.bodyLarge(
                            selected_location.name.isEmpty
                                ? 'Search locations...'
                                : selected_location.name,
                            color: Colors.grey.shade700,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: 600,
                          ),
                        ),
                      ),
                    ),
                    FxContainer(
                      paddingAll: 10,
                      onTap: () {
                        searchIsHidden = false;
                        setState(() {});
                        searchIsHidden = false;
                        try {
                          myFocusNode.requestFocus();
                        } catch (e) {}
                      },
                      color: Colors.white,
                      borderRadiusAll: 100,
                      child: const Icon(FeatherIcons.search, size: 25),
                    ),
                    const SizedBox(
                      width: 5,
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: 165,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "fab2",
                    elevation: 0,
                    mini: false,
                    backgroundColor: CustomTheme.primary,
                    child: const Icon(
                      FeatherIcons.settings,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      _show_map_settings();
                    },
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  FxText.bodySmall(
                    "SETTINGS",
                    color: pathColor,
                    textAlign: TextAlign.center,
                    fontWeight: 800,
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 80,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "fab2",
                    elevation: 0,
                    mini: false,
                    backgroundColor: MyColors.primary,
                    child: const Icon(
                      FeatherIcons.mousePointer,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      Utils.toast('Getting your location...');
                      Position p = await Utils.get_device_location();
                      if (p.latitude != 0) {
                        addMarker("${p.latitude}", '${p.longitude}', 'ME',
                            title: mainController.loggedInUser.name,
                            sub_title: 'My current location on this map.');
                        moveToLatLong("${p.latitude}", '${p.longitude}');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  FxText.bodySmall(
                    "MY LOCATION",
                    color: pathColor,
                    textAlign: TextAlign.center,
                    fontWeight: 800,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                width: Get.width,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: FxButton.block(
                  onPressed: () {

                    if (selected_location.name.isEmpty) {
                      Utils.toast('Please select a location first.');
                      return;
                    }
                    Get.back(result: selected_location);
                  },
                  borderRadiusAll: 100,
                  padding: const EdgeInsets.only(bottom: 24, top: 24),
                  backgroundColor: MyColors.primary,
                  child: FxText.titleLarge(
                    'DONE PICKING LOCATION',
                    maxLines: 1,
                    color: Colors.white,
                    fontWeight: 800,
                  ),
                ),
              ),
            ),
            searchIsHidden
                ? const SizedBox()
                : FxContainer(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                    child: Column(
                      children: [
                        FxCard(
                          padding: const EdgeInsets.only(
                            top: 0,
                            bottom: 0,
                          ),
                          borderRadiusAll: 50,
                          color: Colors.white,
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              FxContainer(
                                paddingAll: 10,
                                onTap: () {
                                  searchIsHidden = true;
                                  setState(() {});
                                },
                                color: Colors.white,
                                borderRadiusAll: 100,
                                child: const Icon(FeatherIcons.arrowLeft),
                              ),
                              Expanded(
                                child: FormBuilder(
                                  key: _formKey,
                                  child: FormBuilderTextField(
                                    name: 'search',
                                    focusNode: myFocusNode,
                                    onChanged: (keyword) {
                                      if (keyword == null || keyword.isEmpty) {
                                        return;
                                      }
                                      searchWord(keyword.toString());
                                    },
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: searchController,
                                    cursorColor: CustomTheme.primary,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              FxContainer(
                                paddingAll: 10,
                                onTap: () {
                                  _formKey.currentState!.reset();
                                  searchController.clear();
                                },
                                color: Colors.white,
                                borderRadiusAll: 100,
                                child: const Icon(FeatherIcons.x),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, position) {
                              return ListTile(
                                onTap: () {
                                  searchIsHidden = true;
                                  selected_location = locations[position];
                                  moveToLatLong(
                                      selected_location.latitude.toString(),
                                      selected_location.longitude.toString(),
                                      zoom: 14);
                                  addMarker(
                                      selected_location.latitude.toString(),
                                      selected_location.longitude.toString(),
                                      'ME',
                                      title: selected_location.name.toString(),
                                      sub_title:
                                          '${selected_location.latitude}, '
                                          '${selected_location.longitude}');
                                  setState(() {});
                                },
                                dense: true,
                                title: FxText.bodyLarge(
                                  locations[position].name.toString(),
                                  fontWeight: 600,
                                  color: Colors.grey.shade800,
                                ),
                                visualDensity: VisualDensity.compact,
                              );
                            },
                            itemCount: locations.length,
                            separatorBuilder: (context, int index) {
                              return const Divider();
                            },
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  MapLocationModel selected_location = MapLocationModel();
  bool searchIsHidden = true;

  Future<void> _init_content() async {
    Utils.toast('Loading map...');
    return;
  }

  Set<Marker> markers = <Marker>{};

  Future<void> addMarker(
    String lat,
    String long,
    String markId, {
    String title = "Mark",
    String sub_title = "",
  }) async {
    markers.add(
      Marker(
        markerId: MarkerId(markId),
        position: LatLng(double.parse(lat), double.parse(long)),
        infoWindow: InfoWindow(
          title: title,
          snippet: sub_title,
        ),
      ),
    );
    setState(() {});
    selectLocation(double.parse(lat), double.parse(long));
  }

  selectLocation(double lat, double long) async {
    var dio = Dio();

    var resp = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$googleAPiKey');
    if (resp == null) {
      return;
    }
    if (resp.data != null &&
        resp.data['results'] != null &&
        resp.data['results'].length > 0) {
      selected_location.name = resp.data['results'][0]['formatted_address'];
      selected_location.address = resp.data['results'][0]['formatted_address'];
      setState(() {});
    }
  }

  String googleAPiKey = AppConfig.GOOGLE_MAP_API;

  LatLng startLocation = const LatLng(27.6683619, 85.3101895);
  LatLng endLocation = const LatLng(27.6688312, 85.3077329);

  Color pathColor = Colors.black;

  detailWidget(String title, String value) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          FxText.bodyLarge(
            title.toUpperCase(),
            fontWeight: 600,
            color: Colors.grey.shade800,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: FxText.bodyLarge(
              value,
              color: Colors.grey.shade700,
              fontWeight: 500,
            ),
          ),
        ],
      ),
    );
  }

  void _show_map_settings() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.2),
        builder: (BuildContext buildContext) {
          return FxContainer(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: FxText.titleLarge(
                    "CHANGE MAP TYPE",
                    color: CustomTheme.primary,
                    fontSize: 18,
                    fontWeight: 800,
                  ),
                ),
                ListTile(
                  leading: const Icon(FeatherIcons.arrowRight),
                  onTap: () {
                    mapType = MapType.normal;
                    pathColor = Colors.black;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  minVerticalPadding: 0,
                  title: FxText.titleMedium(
                    'Normal map',
                    color: Colors.black,
                    height: 1,
                    fontWeight: 600,
                  ),
                ),
                ListTile(
                  leading: const Icon(FeatherIcons.arrowRight),
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    mapType = MapType.satellite;
                    pathColor = Colors.white;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  minVerticalPadding: 0,
                  title: FxText.titleMedium(
                    'Satellite map',
                    color: Colors.black,
                    fontWeight: 600,
                    height: 1,
                  ),
                ),
                ListTile(
                  leading: const Icon(FeatherIcons.arrowRight),
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    mapType = MapType.terrain;
                    pathColor = Colors.black;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  minVerticalPadding: 0,
                  title: FxText.titleMedium(
                    'Terrain map',
                    color: Colors.black,
                    fontWeight: 600,
                    height: 1,
                  ),
                ),
                ListTile(
                  leading: const Icon(FeatherIcons.arrowRight),
                  visualDensity: VisualDensity.compact,
                  onTap: () {
                    mapType = MapType.hybrid;
                    pathColor = Colors.white;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  minVerticalPadding: 0,
                  title: FxText.titleMedium(
                    'Hybrid map',
                    color: Colors.black,
                    fontWeight: 600,
                    height: 1,
                  ),
                ),
              ],
            ),
          );
        });
  }

  List<MapLocationModel> locations = [];
  final searchController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    searchController.dispose();
    super.dispose();
  }

  int wait_time = 0;

  Future<void> searchWord(String keyword) async {
    setState(() {
      locations = [];
    });

    if (keyword.isEmpty) {
      return;
    }

    var dio = Dio();
    var resp = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$keyword,Uganda&key=$googleAPiKey');
    if (resp == null) {
      return;
    }
    for (var x in resp.data['results']) {
      MapLocationModel obj = MapLocationModel();
      obj.name = x['formatted_address'];
      obj.latitude = x['geometry']['location']['lat'];
      obj.longitude = x['geometry']['location']['lng'];
      locations.add(obj);
    }
    setState(() {});
  }
}
