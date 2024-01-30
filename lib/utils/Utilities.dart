import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dioPackage;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:omulimisa2/models/DistrictModel.dart';
import 'package:omulimisa2/screens/auth/login_screen.dart';
import 'package:omulimisa2/screens/shop/models/ProductCategory.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../controllers/MainController.dart';
import '../models/DynamicModel.dart';
import '../models/FarmerGroupModel.dart';
import '../models/FarmerQuestion.dart';
import '../models/FarmerQuestionAnswer.dart';
import '../models/LoggedInUserModel.dart';
import '../models/MapLocationModel.dart';
import '../models/MyPermission.dart';
import '../models/ParishModel.dart';
import '../models/SubcountyModel.dart';
import '../screens/shop/models/ChatHead.dart';
import '../screens/shop/models/Product.dart';
import '../screens/shop/screens/shop/chat/ChatsScreen.dart';
import '../screens/shop/screens/shop/chat/chat_screen.dart';
import '../src/network/dio_interceptor.dart';
import 'AppConfig.dart';
import 'CustomTheme.dart';

class Utils {
  static double calculatePolygonArea(List<DynamicModel> points) {
    if (points.isEmpty) {
      return 0.0;
    }
    List<Point<double>> coordinates = [];
    for (int i = 0; i < points.length; i++) {
      coordinates.add(Point(double.parse(points[i].attribute_1),
          double.parse(points[i].attribute_2)));
    }

    int n = coordinates.length;
    double area = 0.0;

    for (int i = 0; i < n; i++) {
      int j = (i + 1) % n;
      area += coordinates[i].x * coordinates[j].y;
      area -= coordinates[i].y * coordinates[j].x;
    }

    area = 0.5 * area.abs();
    return area;
  }

  static String moneyFormat(String price) {
    int value0 = Utils.int_parse(price);
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      if (value0 < 0) {
        value = "-$value";
      }
      return value;
    }
    return price;
  }

  static SystemUiOverlayStyle overlay() {
    return const SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    );
  }

  static Future<List<String>> getDownloadPics() async {
    List<String> downloadedPics = [];
    Directory dir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = dir.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        downloadedPics.add(file.path.split('/').last);
      }
    }
    return downloadedPics;
  }

  static Future<void> downloadPhoto(String pic) async {
    List<String> downloadedPics = await getDownloadPics();
    if (downloadedPics.contains(pic)) {
      return;
    }

    Directory dir = await getApplicationDocumentsDirectory();

    Dio dio = Dio();
    String dirPath = dir.path;

    String url = '${AppConfig.BASE_URL}/storage/images/$pic';
    var response = await dio.download(url, '$dirPath/$pic');
    if (response.statusCode == 200) {
    } else {}
  }

  static Future<List<String>> getFilesInDirectory() async {
    //Directory appDir = await getApplicationDocumentsDirectory();
    Directory appDir = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = appDir.listSync();
    List<String> fileNames = [];

    for (FileSystemEntity file in files) {
      if (file is File) {
        fileNames.add(file.path.split('/').last);
      }
    }

    return fileNames;
  }

  static Future<void> initOneSignal(LoggedInUserModel u) async {
    //await Firebase.initializeApp();
    // Set the background messaging handler early on, as a named top-level function
    OneSignal.shared.setAppId(AppConfig.ONESIGNAL_APP_ID);

    if (u.id > 0) {
      OneSignal.shared.setExternalUserId(u.id.toString());
    }

    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared.setNotificationOpenedHandler(
        (OSNotificationOpenedResult result) async {
      if (result.notification.additionalData != null) {
        Map<String, dynamic>? data = result.notification.additionalData;
        if (data != null) {
          if (data["receiver_id"] != null) {
            if (data["chat_head_id"] != null) {
              MainController mainController = MainController();
              await mainController.getLoggedInUser();
              Get.put(mainController);
              int chatHeadId = Utils.int_parse(data["chat_head_id"]);
              Utils.toast2(chatHeadId.toString());
              if (chatHeadId > 0) {
                LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
                ChatHead chatHead = ChatHead();
                List<ChatHead> chatHeads =
                    await ChatHead.get_items(u, where: "id = $chatHeadId");
                if (chatHeads.isEmpty) {
                  await ChatHead.getOnlineItems();
                  chatHeads =
                      await ChatHead.get_items(u, where: "id = $chatHeadId");
                }
                if (chatHeads.isNotEmpty) {
                  chatHead = chatHeads[0];
                }
                if (chatHead.id > 0) {
                  Get.to(() => ChatScreen(
                        chatHead,
                        Product(),
                      ));
                } else {
                  Get.to(() => const ChatsScreen());
                }
              }
            }
          }
        }
      }
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  static Future<Database> getDb() async {
    return await openDatabase(AppConfig.DATABASE_PATH,
        version: Utils.int_parse(AppConfig.APP_VERSION));
  }

  static void system_boot() {
    //AdminRole.get_items();
    DistrictModel.get_items();
    SubcountyModel.get_items();
    MyPermission.get_items();
    //MyRole.get_items();
    FarmerQuestion.get_items();
    FarmerQuestionAnswer.get_items();
    ParishModel.get_items();
    ProductCategory.getItems();
    Product.getItems();
    DistrictModel.get_items();
    FarmerGroupModel.get_items();
  }

  static void init_theme() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary,
      ),
    );
  }

  static Future<Position> get_device_location() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
    }

    return await Geolocator.getCurrentPosition();
  }

  static String to_date(dynamic updatedAt) {
    String dateText = "--:--";
    if (updatedAt == null) {
      return "--:--";
    }
    if (updatedAt.toString().length < 5) {
      return "--:--";
    }

    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("d MMM, y - ").format(date);
      dateText += DateFormat("jm").format(date);
    } catch (e) {}

    return dateText;
  }

  static String getImageUrl(dynamic img) {
    String img0 = "logo.png";
    if (img != null) {
      img = img.toString();
      if (img.toString().isNotEmpty) {
        img0 = img;
      }
    }
    img0.replaceAll('/images', '');
    return "${AppConfig.MAIN_SITE_URL}/storage/images/$img0";
  }

  static String to_date_1(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }

    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("d MMM, y").format(date);
    } catch (e) {}

    return dateText;
  }

  static DateTime toDate(dynamic updatedAt) {
    DateTime date = DateTime.now();
    try {
      date = DateTime.parse(updatedAt.toString());
    } catch (e) {
      date = DateTime.now();
    }

    return date;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await deleteDatabase(AppConfig.DATABASE_PATH);
    Get.offAll(const LoginScreen());
    return;
  }

  static String replaceAfterDot(String originalString, String replacement) {
    List<String> parts = originalString.split('.');

    if (parts.length > 1) {
      parts[1] = replacement;
      return parts.join('.');
    } else {
      return originalString;
    }
  }

  static String to_date_2(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }
    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("EEEE - dd MMM, y").format(date);
    } catch (e) {}
    return dateText;
  }

  static String to_date_3(dynamic updatedAt) {
    String dateText = "__/__/___";
    if (updatedAt == null) {
      return "__/__/____";
    }
    if (updatedAt.toString().length < 5) {
      return "__/__/____";
    }
    try {
      DateTime date = DateTime.parse(updatedAt.toString());

      dateText = DateFormat("jm").format(date);
    } catch (e) {}
    return dateText;
  }

  static String to_str(dynamic x, String y) {
    if (x == null) {
      return y;
    }
    if (x.toString().toString() == 'null') {
      return y;
    }
    if (x.toString().isEmpty) {
      return y.toString();
    }
    if (x is List<String> && x.isNotEmpty) {
      // If x is a list of strings, join them with ', ' separator
      return jsonEncode(x);
    }

    return x.toString();
  }

  static int int_parse(dynamic x) {
    if (x == null) {
      return 0;
    }
    int temp = 0;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    return temp;
  }

  static bool bool_parse(dynamic x) {
    int temp = 0;
    bool ans = false;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    if (temp == 1) {
      ans = true;
    } else {
      ans = false;
    }
    return ans;
  }

  static Future<dynamic> http_post(
      String path, Map<String, dynamic> body) async {
    bool isOnline = await Utils.is_connected();
    if (!isOnline) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }
    dynamic response;
    var dio = Dio()..interceptors.add(DioInterceptor());
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    // LoggedInUserModel userModel = await LoggedInUserModel.getLoggedInUser();
    // String token = userModel.token;
    // body['user_id'] = LoggedInUserModel.id;
    body['logged_in_user_id'] = 1;
    var da = dioPackage.FormData.fromMap(body); //.fromMap();
    try {
      response = await dio.post("${AppConfig.API_BASE_URL}/$path",
          data: da,
          options: Options(
            headers: <String, String>{

              "Content-Type": "application/json",
              "Accept": "application/json",
              "logged_in_user_id": "1",
            },
          ));
      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }
      }
      Map<String, dynamic> map = {
        'status': 0,
        'message': "Failed because ${e.message.toString()}"
      };
      return jsonEncode(map);
    }
  }

  static Future<dynamic> http_get(String path, Map<String, dynamic> body,
      {bool addBase = true}) async {
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    // body['user_id'] = u.id;
    //print url
    print("${AppConfig.API_BASE_URL}/$path");

    bool isOnline = await Utils.is_connected();
    if (!isOnline) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }

    dioPackage.Response response;
    var dio = Dio()..interceptors;

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    try {
      response =
      await dio.get(addBase ? "${AppConfig.API_BASE_URL}/$path" : path,
              queryParameters: body,
              options: Options(
                headers: {
                  "authorization": "Bearer ${u.token}",
                  //  "User-Id": '${u.id}',
                  'Content-Type': 'application/json; charset=UTF-8',
                  'accept': 'application/json',
                },
              ));

      return response.data;
    } on DioException catch (e) {
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }
      }
      return {
        'status': 0,
        'code': 0,
        'message': e.response?.data,
        'data': null,
      };
    }
  }

  static Future<bool> is_connected() async {
    return await InternetConnectionChecker().hasConnection;
    // bool is_connected = false;
    // var connectivityResult = await (Connectivity().checkConnectivity());
    //
    // if (connectivityResult == ConnectivityResult.mobile) {
    //   // I am connected to a mobile network.
    //   is_connected = true;
    // } else if (connectivityResult == ConnectivityResult.wifi) {
    //   // I am connected to a wifi network.
    //   is_connected = true;
    // }
    //
    // return is_connected;
  }

  static log(String message) {
    debugPrint(message, wrapWidth: 1200);
  }

  static void toast2(String message,
      {Color background_color = CustomTheme.primary,
      color = Colors.white,
      bool is_long = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }

    Fluttertoast.showToast(
        msg: message,
        toastLength: is_long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: background_color,
        textColor: color,
        fontSize: 16.0);
  }

  static Future<MapLocationModel> searchWord(String keyword) async {
    MapLocationModel obj = MapLocationModel();
    if (keyword.isEmpty) {
      return obj;
    }

    var dio = Dio();
    var resp = await dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$keyword,Uganda&key=${AppConfig.GOOGLE_MAP_API}');
    if (resp == null) {
      return obj;
    }
    for (var x in resp.data['results']) {
      obj.name = x['formatted_address'];
      obj.latitude = x['geometry']['location']['lat'];
      obj.longitude = x['geometry']['location']['lng'];
      break;
    }
    return obj;
  }

  static toast(String message,
      {Color color = Colors.green, bool isLong = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }
    Utils.toast2(message, is_long: isLong);
    return;

    Get.snackbar('Alert', message,
        dismissDirection: DismissDirection.down,
        colorText: Colors.white,
        backgroundColor: color,
        margin: EdgeInsets.zero,
        duration:
            isLong ? const Duration(seconds: 3) : const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED);
  }
}
