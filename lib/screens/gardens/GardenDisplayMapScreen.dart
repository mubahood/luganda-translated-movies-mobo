import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../controllers/MainController.dart';
import '../../models/RespondModel.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';
import '../../utils/my_colors.dart';
import '../farmer_questions/FarmerQuestionScreen.dart';

class GardenDisplayMapScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  GardenDisplayMapScreen(this.params, {super.key});

  @override
  State<GardenDisplayMapScreen> createState() => GardenDisplayMapScreenState();
}

class GardenDisplayMapScreenState extends State<GardenDisplayMapScreen> {
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
  final MainController myMainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: Get.height,
              padding: const EdgeInsets.only(bottom: 65),
              width: Get.width,
              child: GoogleMap(
                mapType: mapType,
                trafficEnabled: false,
                initialCameraPosition: _kGooglePlex,
                markers: markers,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                polygons: _polygon,
/*                polylines: Set<Polyline>.of(polylines.values),*/
                onTap: (LatLng x) {
                  print("${x.latitude},${x.longitude}");
                },
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
              child: FloatingActionButton(
                heroTag: "fab2",
                elevation: 0,
                mini: false,
                backgroundColor: MyColors.primary,
                child: const Icon(
                  FeatherIcons.arrowLeft,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Get.back(); //go back to previous screen
                },
              ),
            ),
            Positioned(
              right: 10,
              bottom: 410,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "fab2",
                    elevation: 0,
                    mini: false,
                    backgroundColor: MyColors.primary,
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
              bottom: 325,
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
                      Utils.toast2('Please wait...');
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
                    "ME",
                    color: pathColor,
                    textAlign: TextAlign.center,
                    fontWeight: 800,
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 245,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "fab2",
                    elevation: 0,
                    mini: false,
                    backgroundColor: MyColors.primary,
                    child: const Icon(
                      FeatherIcons.flag,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      /*moveToLatLong("${trip.trip_destination_latitude}",
                          '${trip.trip_destination_longitude}');*/
                    },
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  FxText.bodySmall(
                    "DESTINATION",
                    fontSize: 8,
                    color: pathColor,
                    textAlign: TextAlign.center,
                    fontWeight: 800,
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 160,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "fab2",
                    elevation: 0,
                    mini: false,
                    backgroundColor: MyColors.primary,
                    child: const Icon(
                      FeatherIcons.truck,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      /*moveToLatLong("${trip.current_latitude}",
                          '${trip.current_longitude}');*/
                    },
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  FxText.bodySmall(
                    "NOW",
                    color: pathColor,
                    textAlign: TextAlign.center,
                    fontWeight: 800,
                  )
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 75,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "fab2",
                    elevation: 0,
                    mini: false,
                    backgroundColor: MyColors.primary,
                    child: const Icon(
                      FeatherIcons.mapPin,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      /*moveToLatLong(
                          "${trip.start_latitude}", '${trip.start_longitude}');*/
                    },
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  FxText.bodySmall(
                    "ORIGIN",
                    color: pathColor,
                    textAlign: TextAlign.center,
                    fontWeight: 800,
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: ('Yes' == 'Yes')
                    ? Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: Get.width,
                        child: FxButton.block(
                            onPressed: () {
                              getDirections();
                              return;
                              Get.defaultDialog(
                                  middleText:
                                      "Are you sure you want to end this trip?",
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
                                        end_trip();
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 15),
                                      backgroundColor: Colors.green,
                                      child: FxText(
                                        'END TRIP',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ]);
                            },
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Colors.red.shade700,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FxText.titleLarge(
                                  'END TRIP',
                                  color: Colors.white,
                                  fontWeight: 800,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(FeatherIcons.stopCircle)
                              ],
                            )),
                      )
                    : FxContainer(
                        onTap: () {
                          _show_trip_details();
                        },
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          top: 15,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        width: Get.width,
                        color: MyColors.primary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FxContainer(
                              width: 180,
                              height: 10,
                              paddingAll: 0,
                              padding: FxSpacing.all(10),
                              color: Colors.white,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 5,
                                ),
                                FxText.titleMedium(
                                  "View Trip Details",
                                  fontWeight: 800,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  FeatherIcons.chevronDown,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        )))
          ],
        ),
      ),
      floatingActionButton: true
          ? null
          : FloatingActionButton.extended(
              onPressed: _init_content,
              label: const Text('To the lake!'),
              icon: const Icon(Icons.directions_boat),
            ),
    );
  }

  Future<void> _init_content() async {
    //Utils.toast2('Loading map...');
    /* addMarker("${trip.start_latitude}", '${trip.start_longitude}', 'Origin');
    addMarker("${trip.trip_destination_latitude}",
        '${trip.trip_destination_longitude}', 'Destination');
    await getDirections();
    moveToLatLong("${trip.current_latitude}", '${trip.current_longitude}',
        zoom: 12);*/
    updateMyLocation();
    return;
  }

  Set<Marker> markers = <Marker>{};

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
    setState(() {});
  }

  bool isDriver = false;

  updateMyLocation() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          systemNavigationBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: true,
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarDividerColor: MyColors.primary,
          systemStatusBarContrastEnforced: true),
    );

    carIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/icons/track.png");
  }

  _update_user() async {
    setState(() {});
    /*   markers.add(
      Marker(
        markerId: MarkerId('Current'),
        position: LatLng(double.parse(trip.current_latitude),
            double.parse(trip.current_longitude)),
        icon: carIcon,
        draggable: false,
        infoWindow: InfoWindow(
            title: trip.transporter_name, snippet: trip.current_address),
      ),
    );*/

    /* if (trip.has_trip_ended != 'Yes' && !isDriver) {
      List<Trip> trips = await Trip.get_items(where: ' id = ${trip.id}');
      if (trips.length > 0) {
        trip = trips[0];
      }
      setState(() {});
      await Future.delayed(Duration(seconds: 2));
      _update_user(); //update user location
      return;
    }*/
  }

  _update_driver() async {
    Position p = await Utils.get_device_location();
    if (p.latitude == 0) {
      /* Utils.toast("Please enable location services and try again.",
          is_long: true);*/
      Get.back();
      return;
    }

    setState(() {});
    markers.add(
      Marker(
        markerId: const MarkerId('Current'),
        position: LatLng(p.latitude, p.longitude),
        icon: carIcon,
        draggable: false,
        infoWindow: InfoWindow(
          title: 'Current Location',
          snippet: '${p.latitude},${p.longitude}',
        ),
      ),
    );

/*    MapLocationModel locationModel =
        await Utils.gpsToAddress(p.latitude, p.longitude);*/
    setState(() {});
    RespondModel r = RespondModel(await Utils.http_post('api/trip-records/', {
      'latitude': p.latitude.toString(),
      'longitude': p.longitude.toString(),
    }));

    if (r.code != 1) {
      Utils.toast2(r.message, is_long: true, background_color: Colors.red);
      await Future.delayed(const Duration(seconds: 4));
      _update_driver();
      return;
    }

    await Future.delayed(const Duration(seconds: 4));
    _update_driver();

    await Future.delayed(const Duration(seconds: 2));
    Position pos = await Utils.get_device_location();
    //moveToLatLong("${p.latitude}", '${p.longitude}');
    addMarker("${pos.latitude}", '${pos.longitude}', 'ME WALKING');
    print("${pos.latitude}" ',${pos.longitude}');
    updateMyLocation();
  }

  end_trip() async {
    Utils.toast2("Ending trip...");
    setState(() {});

/*    RespondModel r = RespondModel(await Utils.http_post('api/trip-end/', {
      'trip_id': trip.id.toString(),
    }));*/
/*
    if (r.code != 1) {
      Utils.toast2(r.message, is_long: true, background_color: Colors.red);
      await Future.delayed(Duration(seconds: 4));
      _update_driver();
      return;
    }
    trip.has_trip_ended = 'Yes';
    trip.save();
    Trip.get_items();
    Utils.toast2(r.message, is_long: true, background_color: Colors.green);
    Get.back();*/
  }

  Map<PolylineId, Polyline> polylines = {}; //poly-lines to show direction
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = AppConfig.GOOGLE_MAP_API;

  LatLng startLocation = const LatLng(27.6683619, 85.3101895);
  LatLng endLocation = const LatLng(27.6688312, 85.3077329);
  final Set<Polygon> _polygon = HashSet<Polygon>();

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    polylineCoordinates.add(const LatLng(0.3790889216320615, 32.592057175934315));
    polylineCoordinates.add(const LatLng(0.3803780300272048, 32.597157061100006));
    polylineCoordinates.add(const LatLng(0.3804299966814828, 32.60102245956659));
    polylineCoordinates.add(const LatLng(0.3803780300272048, 32.60395176708698));
    polylineCoordinates.add(const LatLng(0.38009573374488986, 32.60843474417925));
    polylineCoordinates.add(const LatLng(0.3780656812296203, 32.611416690051556));
    polylineCoordinates.add(const LatLng(0.37284152078875826, 32.6125817745924));
    polylineCoordinates.add(const LatLng(0.37052916999800917, 32.61251103132963));
    polylineCoordinates.add(const LatLng(0.37065355483916573, 32.60898157954216));
    polylineCoordinates.add(const LatLng(0.3710065932063331, 32.605504766106606));
    polylineCoordinates.add(const LatLng(0.37310705385510895, 32.602928169071674));
    polylineCoordinates.add(const LatLng(0.3744648932735856, 32.60407514870167));
    polylineCoordinates.add(const LatLng(0.3722249610242452, 32.60102245956659));
    polylineCoordinates.add(const LatLng(0.37005375837874377, 32.599327974021435));
    polylineCoordinates.add(const LatLng(0.3685530936082467, 32.60252248495817));
    polylineCoordinates.add(const LatLng(0.3675466154412811, 32.606457620859146));
    polylineCoordinates.add(const LatLng(0.3646177029828132, 32.60910462588072));
    polylineCoordinates.add(const LatLng(0.3574881977072677, 32.606934048235416));
    polylineCoordinates.add(const LatLng(0.35708319202053934, 32.604287043213844));
    polylineCoordinates.add(const LatLng(0.3557236736288734, 32.60082799941301));
    polylineCoordinates.add(const LatLng(0.35558252509877863, 32.59763415902853));
    polylineCoordinates.add(const LatLng(0.35722434052761964, 32.59382240474224));
    polylineCoordinates.add(const LatLng(0.361352849579836, 32.59184528142214));
    polylineCoordinates.add(const LatLng(0.363594460905352, 32.5915103405714));
    polylineCoordinates.add(const LatLng(0.3680776818832978, 32.590698301792145));
    polylineCoordinates.add(const LatLng(0.37112930169531927, 32.59015146642923));
    polylineCoordinates.add(const LatLng(0.37303631209200144, 32.591245137155056));

    addPolyLine(polylineCoordinates);

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        const CameraPosition(
            target: LatLng(0.3790889216320615, 32.592057175934315),
            zoom: 14.0)));
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    /*PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      visible: true,
      color: MyColors.primary,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;*/
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
  }

  Color pathColor = Colors.black;

  void _show_trip_details() {
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
                    "TRIP DETAILS",
                    color: CustomTheme.primary,
                    fontSize: 18,
                    fontWeight: 800,
                  ),
                ),
                Expanded(
                    child: ListView(
                  children: [
                    detailWidget("Trip ID: ", "trip.id"),
                    detailWidget("movement permits: ", "trip.permits"),
                  ],
                ))
              ],
            ),
          );
        });
  }

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
}
