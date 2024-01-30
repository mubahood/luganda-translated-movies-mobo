import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:omulimisa2/models/DynamicModel.dart';
import 'package:omulimisa2/utils/my_colors.dart';

import '../../controllers/MainController.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utilities.dart';

class GardenCreateMapScreen extends StatefulWidget {
  List<DynamicModel> coordicates = [];

  GardenCreateMapScreen(this.coordicates, {super.key});

  @override
  State<GardenCreateMapScreen> createState() => GardenCreateMapScreenState();
}

class GardenCreateMapScreenState extends State<GardenCreateMapScreen> {
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

    try {
      for (var el in widget.coordicates) {
        polylineCoordinates.add(
            LatLng(double.parse(el.attribute_1), double.parse(el.attribute_2)));
        markers.add(
          Marker(
            markerId: MarkerId(el.id.toString()),
            position: LatLng(
                double.parse(el.attribute_1), double.parse(el.attribute_2)),
            infoWindow: InfoWindow(
              title: 'Mark ${el.id}',
            ),
          ),
        );
      }
    } catch (c) {}

    Utils.toast("Loading...");
    initScreen();
  }

  BitmapDescriptor carIcon = BitmapDescriptor.defaultMarker;

  Future<void> initScreen() async {}

  late final GoogleMapController controller;

  bool mapReady = false;

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
          zoom: 20);
      await controller.animateCamera(CameraUpdate.newCameraPosition(pos));
    } else {
      zoom = await controller.getZoomLevel();
      CameraPosition pos = CameraPosition(
          target: LatLng(double.parse(lat), double.parse(long)), zoom: zoom);
      await controller.animateCamera(CameraUpdate.newCameraPosition(pos));
    }
  }

  MapType mapType = MapType.normal;
  final MainController myMainController = Get.find<MainController>();
  Set<Marker> markers = <Marker>{};
  double size = 0;

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
                  isMapping = false;
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
            children: [
              FxText.titleLarge(
                "Mapping a garden",
                color: Colors.white,
              ),
              //truncate size
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
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: Get.height,
                padding: const EdgeInsets.only(
                  bottom: 65,
                ),
                width: Get.width,
                child: GoogleMap(
                  mapType: mapType,
                  trafficEnabled: false,
                  initialCameraPosition: _kGooglePlex,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  polygons: _polygon,
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapCompleted();
                  },
                ),
              ),
              Positioned(
                bottom: 0,
                child: FxContainer(
                  width: Get.width,
                  height: 85,
                  child: isMapping
                      ? FxButton.block(
                          onPressed: () {
                            Get.defaultDialog(
                                middleText:
                                    "Are you sure you want to STOP mapping?",
                                titleStyle: const TextStyle(color: Colors.black),
                                actions: <Widget>[
                                  FxButton.small(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    backgroundColor: Colors.red,
                                    child: FxText(
                                      'CANCEL',
                                      color: Colors.white,
                                    ),
                                  ),
                                  FxButton.small(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      isMapping = false;
                                      setState(() {});
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 15),
                                    backgroundColor: Colors.green,
                                    child: FxText(
                                      'STOP MAPPING',
                                      color: Colors.white,
                                    ),
                                  ),
                                ]);
                          },
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: Colors.red.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FxText.titleLarge(
                                'STOP MAPPING',
                                color: Colors.white,
                                fontWeight: 800,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(FeatherIcons.stopCircle)
                            ],
                          ))
                      : widget.coordicates.isNotEmpty
                          ? Row(
                              children: [
                                Expanded(
                                    child: FxButton.block(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        middleText:
                                            "Are you sure you want to STOP clear all coordinates?",
                                        titleStyle:
                                            const TextStyle(color: Colors.black),
                                        actions: <Widget>[
                                          FxButton.small(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                            backgroundColor: Colors.green,
                                            child: FxText(
                                              'CANCEL',
                                              color: Colors.white,
                                            ),
                                          ),
                                          FxButton.small(
                                            onPressed: () {
                                              do_clear();
                                              Navigator.pop(context);
                                              isMapping = false;
                                              setState(() {});
                                            },
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 15),
                                            backgroundColor: Colors.red,
                                            child: FxText(
                                              'CLEA ALL',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ]);
                                  },
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  backgroundColor: Colors.red.shade800,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FxText.titleLarge(
                                        'CLEAR ALL',
                                        color: Colors.white,
                                        fontWeight: 800,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(FeatherIcons.trash2)
                                    ],
                                  ),
                                )),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: FxButton.block(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  backgroundColor: Colors.green.shade800,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FxText.titleLarge(
                                        'DONE',
                                        color: Colors.white,
                                        fontWeight: 800,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Icon(FeatherIcons.check)
                                    ],
                                  ),
                                )),
                              ],
                            )
                          : FxButton.block(
                              onPressed: () {
                                if (!mapReady) {
                                  Utils.toast(
                                      "Map is not ready. Please enable your GPS");
                                  return;
                                }
                                isMapping = true;
                                setState(() {});
                                collect_gps_for_mapping();
                              },
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              backgroundColor: Colors.green.shade800,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText.titleLarge(
                                    'START MAPPING',
                                    color: Colors.white,
                                    fontWeight: 800,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(FeatherIcons.play)
                                ],
                              ),
                            ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isMapping = false;
  Position? initialPosition;

  Future<void> _init_content() async {
    if (widget.coordicates.isNotEmpty) {
      var x = widget.coordicates.first;
      moveToLatLong(x.attribute_1, x.attribute_2, zoom: 20);
    } else {
      initialPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (initialPosition == null || initialPosition?.latitude == 0) {
        Utils.toast("Please enable GPS");
      } else {
        moveToLatLong(initialPosition!.latitude.toString(),
            initialPosition!.longitude.toString(),
            zoom: 20);
      }
    }
    setState(() {});

    if (polylineCoordinates.length < 2) {
      return;
    }

    size = Utils.calculatePolygonArea(widget.coordicates);
    _polygon.add(
      Polygon(
          polygonId: const PolygonId('x'),
          points: polylineCoordinates,
          fillColor: Colors.black,
          geodesic: true,
          strokeWidth: 10,
          strokeColor: Colors.red),
    );
    setState(() {});
    return;
  }

  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = AppConfig.GOOGLE_MAP_API;
  final Set<Polygon> _polygon = HashSet<Polygon>();

  bool isPicking = false;

  Future<void> collect_gps_for_mapping() async {
    if (!mapReady) {
      Utils.toast("Map is not ready. Please enable your GPS");
      return;
    }

    if (!isMapping) {
      return;
    }
    if (isPicking) {
      return;
    }
    Position p = await Utils.get_device_location();
    if (p.latitude == 0) {
      Utils.toast("Please enable GPS");
    }

    DynamicModel newPosition = DynamicModel();
    newPosition.id = (widget.coordicates.length + 1).toString();
    newPosition.attribute_1 = p.latitude.toString();
    newPosition.attribute_2 = p.longitude.toString();
    widget.coordicates.add(newPosition);
    polylineCoordinates.add(LatLng(p.latitude, p.longitude));
    addMarker(p.latitude.toString(), p.longitude.toString(),
        '${polylineCoordinates.length}',
        title: 'Mark ${polylineCoordinates.length}');
    setState(() {});
    update_polygon();
    await Future.delayed(const Duration(seconds: 3));
    collect_gps_for_mapping();
  }

  List<LatLng> polylineCoordinates = [];

  update_polygon() async {
    if (!mapReady) {
      Utils.toast("Map is not ready.");
      return;
    }

    if (polylineCoordinates.length < 2) {
      return;
    }

    _polygon.add(
      Polygon(
          polygonId: const PolygonId('x'),
          points: polylineCoordinates,
          fillColor: MyColors.primary,
          geodesic: true,
          strokeWidth: 1,
          visible: true,
          strokeColor: Colors.red),
    );

    setState(() {});
  }

  void addMarker(
    String lat,
    String long,
    String markId, {
    String title = "Mark",
    String sub_title = "",
  }) {
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
    moveToLatLong(lat, long);
    setState(() {});
  }

  void do_clear() {
    widget.coordicates.clear();
    markers.clear();
    polylineCoordinates.clear();
    update_polygon();
    setState(() {});
  }
}
