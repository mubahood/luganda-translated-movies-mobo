// ignore: file_names
// ignore: file_names
import 'package:get/get.dart';
import 'package:omulimisa2/models/LoggedInUserModel.dart';
import 'package:omulimisa2/models/ResourceModel.dart';

import '../models/FarmerQuestion.dart';
import '../models/MyPermission.dart';
import '../models/MyRole.dart';
import '../models/WeatherForeCastModel.dart';
import '../screens/shop/models/CartItem.dart';
import '../screens/shop/models/OrderOnline.dart';
import '../screens/shop/models/Product.dart';
import '../screens/shop/models/ProductCategory.dart';
import '../utils/Utilities.dart';

class MainController extends GetxController {
  // ignore: non_constant_identifier_names
  RxList<dynamic> weatherItems = <WeatherItem>[].obs;
  RxList<dynamic> weatherItem = <WeatherItem>[].obs;
  LoggedInUserModel loggedInUser = LoggedInUserModel();
  LoggedInUserModel userModel = LoggedInUserModel();
  List<ResourceModel> resources = [];
  List<FarmerQuestion> questions = [];
  RxList<dynamic> categories = <ProductCategory>[].obs;

  RxList<dynamic> cartItems = <CartItem>[].obs;
  RxList<dynamic> myOrders = <OrderOnline>[].obs;
  RxList<dynamic> myProducts = <Product>[].obs;
  RxList<dynamic> products = <Product>[].obs;

  init() async {
    await getLoggedInUser();
    await getWeather('1.003567', '34.334366');
    await getResources();
    await getQuestions();
    await getCartItems();
    await getMyProducts();
    await getProducts();
    await getOrders();
  }

  getOrders() async {
    myOrders.value = await OrderOnline.getItems();
    update();
  }

  Future<void> getProducts() async {
    products.value = await Product.getItems();
    update();
    return;
  }

  Future<void> getMyProducts() async {
    if (loggedInUser.id < 1) {
      await getLoggedInUser();
    }
    if (loggedInUser.id < 1) {
      myProducts.clear();
      return;
    }
    myProducts.clear();
    for (var element
        in (await Product.getItems(where: 'user = ${loggedInUser.id}'))) {
      myProducts.add(element);
    }
    update();
    return;
  }

  Future<void> addToCart(Product pro) async {
    if (cartItemsIDs.contains(pro.id.toString())) {
      return;
    }
    await CartItem.deleteAll();
    CartItem c = CartItem();
    c.id = pro.id;
    c.product_id = pro.id.toString();
    c.product_name = pro.name;
    c.product_price_1 = pro.price_1;
    c.product_quantity = '1';
    c.product_feature_photo = pro.feature_photo;
    await c.save();
    await getCartItems();
  }

  List<String> cartItemsIDs = [];
  var count = 0.obs;
  var tot = 0.obs;

  getCartItems() async {
    cartItems.clear();
    cartItemsIDs.clear();
    tot.value = 0;
    for (var element in (await CartItem.getItems())) {
      cartItems.add(element);
      cartItemsIDs.add(element.id.toString());
      tot.value += Utils.int_parse(element.product_quantity) *
          Utils.int_parse(element.product_price_1);
    }
    update();
  }

  Future<void> getResources() async {
    resources = await ResourceModel.get_items();
  }

  Future<List<FarmerQuestion>> getQuestions() async {
    questions = await FarmerQuestion.get_items();
    return questions;
  }

  Future<void> getCategories() async {
    categories.value = await ProductCategory.getItems();
    update();
  }

  List<MyRole> roles = [];
  bool canManageFarmers = false;
  bool canAnswerQuestions = false;

  String myRole = "";

  Future<void> getLoggedInUser() async {
    loggedInUser = await LoggedInUserModel.getLoggedInUser();

    canManageFarmers = false;
    loggedInUser.permissions.clear();
    if (loggedInUser.id > 0) {
      List<MyPermission> roles = await MyPermission.get_items();
      for (var element in roles) {
        if (element.slug == 'canManageFarmers') {
          canManageFarmers = true;
        }
        if (element.slug == 'canAnswerQuestions') {
          canAnswerQuestions = true;
        }
        loggedInUser.permissions.add(element.slug);
      }
    }

    userModel = loggedInUser;
    if (loggedInUser.id > 0) {
      List<MyRole> myRoles = await MyRole.get_items();
      myRole = "";
      if (myRoles.isNotEmpty) {
        myRole = myRoles[0].role_name;
      }
    }
    return;
  }

  var raw;

  getWeather(String lati, String long) async {
    raw = await Utils.http_get(
        'https://api.open-meteo.com/v1/forecast?latitude=$lati&longitude=$long&hourly=temperature_2m',
        {},
        addBase: false);
    if (!raw.runtimeType.toString().toLowerCase().contains('map')) {
      return;
    }

    DateTime now = DateTime.now();
    weatherItems.clear();
    weatherItem.clear();
    int j = 0;
    if (raw['hourly'] != null) {
      if (raw['hourly']['time'] != null) {
        if (raw['hourly']['time']
            .runtimeType
            .toString()
            .toLowerCase()
            .contains('list')) {
          for (var x in raw['hourly']['time']) {
            WeatherItem item = WeatherItem();
            if (raw['hourly'] != null) {
              if (raw['hourly']['temperature_2m'] != null) {
                if (raw['hourly']['temperature_2m'][j] != null) {
                  item.weather = raw['hourly']['temperature_2m'][j].toString();
                  j++;
                }
              }
            }
            DateTime time = DateTime.parse(x.toString());
            item.time = x.toString();

            if (time.weekday == now.weekday &&
                time.day == now.day &&
                time.hour == now.hour) {
              weatherItem.add(item);
            }
            if (time.isBefore(now)) {
              continue;
            }
            weatherItems.add(item);
          }
        }
      }
    }

    update();
  }
}
