// ignore: file_names
// ignore: file_names
import 'package:get/get.dart';
import 'package:ugflix/models/LoggedInUserModel.dart';
import 'package:ugflix/models/MovieModel.dart';
import 'package:ugflix/models/ResourceModel.dart';
import 'package:ugflix/models/ManifestModel.dart'; // <-- Import ManifestModel
import 'package:ugflix/models/ManifestService.dart'; // <-- Import ManifestService

import '../models/FarmerQuestion.dart';
import '../models/MyPermission.dart';
import '../models/MyRole.dart';
import '../models/SeriesModel.dart';
import '../models/WeatherForeCastModel.dart';
import '../screens/shop/models/CartItem.dart';
import '../screens/shop/models/OrderOnline.dart';
import '../screens/shop/models/Product.dart';
import '../screens/shop/models/ProductCategory.dart';
import '../utils/Utilities.dart';

class MainController extends GetxController {
  // --- Existing State Variables ---
  // ignore: non_constant_identifier_names
  RxList<dynamic> weatherItems = <WeatherItem>[].obs;
  RxList<dynamic> weatherItem = <WeatherItem>[].obs;
  LoggedInUserModel loggedInUser = LoggedInUserModel();
  LoggedInUserModel userModel = LoggedInUserModel();
  List<ResourceModel> resources = [];
  List<MovieModel> movies = []; // Keep for potential separate movie listings
  List<SeriesModel> series = []; // Keep for potential separate series listings
  List<FarmerQuestion> questions = [];
  RxList<dynamic> categories = <ProductCategory>[].obs;

  RxList<dynamic> cartItems = <CartItem>[].obs;
  RxList<dynamic> myOrders = <OrderOnline>[].obs;
  RxList<dynamic> myProducts = <Product>[].obs;
  RxList<dynamic> products = <Product>[].obs;
  RxList<dynamic> watchedMovies = <MovieModel>[].obs;

  // --- New Manifest State ---
  final ManifestService _manifestService = ManifestService(); // Instance of the service
  Rx<ManifestModel?> manifestModel = Rx<ManifestModel?>(null); // Observable for manifest data
  RxBool isManifestLoading = false.obs; // Observable loading state for manifest


  /// Initializes essential data for the controller.
  /// Loads the manifest first, then other relevant data.
  init() async {
    // Load the manifest data initially
    await loadManifest();

    // Load other data - consider if some of this can be derived from the manifest
    await getMovies(); // Keep if needed separately from manifest lists
    await getWatchedMovies();

    // Other initializations (conditionally keep based on app needs)
    // Uncomment or keep these as required by your application flow
    // await getLoggedInUser();
    // await getWeather('1.003567', '34.334366'); // Example location
    // await getQuestions();
    // await getCartItems();
    // await getMyProducts();
    // await getProducts();
    // await getOrders();

    return; // Explicit return
  }

  /// Fetches and updates the manifest data from the service.
  Future<void> loadManifest() async {
    isManifestLoading.value = true;
    try {
      final data = await _manifestService.getManifest();
      manifestModel.value = ManifestModel.fromJson(data);
      // Optional: You could potentially populate 'movies' or other lists
      // here if the manifest is the primary source, e.g.:
      // _populateDataFromManifest();
    } catch (e) {
      print("Error loading manifest: $e");
      manifestModel.value = null; // Set to null on error
      // Optionally show a user-facing error message via Get.snackbar
    } finally {
      isManifestLoading.value = false;
      update(); // Notify listeners
    }
  }

  // --- Existing Methods (potentially refactor based on manifest) ---

  Future<void> getWatchedMovies() async {
    // This likely remains independent of the manifest
    watchedMovies.value = await MovieModel.get_items(
      where: "watched_movie = 'Yes'",
    );
    update();
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
    // Use await here
    myProducts.value = await Product.getItems(where: 'user = ${loggedInUser.id}');
    // The loop below is redundant if getItems returns the correct list
    /* for (var element
        in (await Product.getItems(where: 'user = ${loggedInUser.id}'))) {
      myProducts.add(element);
    } */
    update();
    return;
  }

  Future<void> addToCart(Product pro) async {
    // Consider checking if product ID exists before parsing
    if (cartItemsIDs.contains(pro.id.toString())) {
      // Maybe update quantity instead of just returning?
      // For now, prevents duplicates based on original logic.
      return;
    }
    // Assuming you want to clear cart and add only the new item based on deleteAll call
    await CartItem.deleteAll(); // This clears the entire cart! Is this intended?

    CartItem c = CartItem();
    // Use Product properties directly
    c.id = pro.id; // Using Product ID as CartItem ID? Might need separate auto-increment ID.
    c.product_id = pro.id.toString();
    c.product_name = pro.name;
    c.product_price_1 = pro.price_1; // Assuming price_1 is String
    c.product_quantity = '1'; // Default quantity
    c.product_feature_photo = pro.feature_photo;

    await c.save();
    await getCartItems(); // Refresh cart state
  }

  List<String> cartItemsIDs = [];
  var count = 0.obs; // Consider renaming for clarity (e.g., cartItemCount)
  var tot = 0.obs; // Consider renaming for clarity (e.g., cartTotal)

  getCartItems() async {
    // Clear current state
    cartItems.clear();
    cartItemsIDs.clear();
    tot.value = 0;

    // Fetch items
    final items = await CartItem.getItems();
    for (var element in items) {
      cartItems.add(element);
      // Ensure element.id is not null before calling toString()
      cartItemsIDs.add(element.id.toString() ?? ''); // Handle potential null ID
      // Calculate total safely
      tot.value += (Utils.int_parse(element.product_quantity) *
          Utils.int_parse(element.product_price_1));
    }
    count.value = cartItems.length; // Update count based on fetched items
    update();
  }

  /// Fetches movies and series. Consider if this should use the manifestModel.
  Future<void> getMovies() async {
    // If manifestModel holds the definitive movie list, use it instead.
    // Example check:
    if (manifestModel.value != null && manifestModel.value!.lists.isNotEmpty) {
      // Populate from manifest if desired, otherwise keep separate fetch:
      // movies = manifestModel.value!.lists.expand((list) => list.movies).toList(); // Example
      print("Using separate fetch for MovieModel/SeriesModel.");
      movies = await MovieModel.get_items(
        where: 'status = "Active" AND type = "Movie"', // Assuming correct table/logic
      );
      series = await SeriesModel.get_items(); // Assuming correct table/logic
    } else {
      // Fallback or default fetch if manifest is empty or not used for this
      print("Manifest not ready or not used, fetching MovieModel/SeriesModel separately.");
      movies = await MovieModel.get_items(
        where: 'status = "Active" AND type = "Movie"',
      );
      series = await SeriesModel.get_items();
    }

    // Sort fetched movies if needed
    movies.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0)); // Handle potential null IDs

    update();
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
    canAnswerQuestions = false; // Reset flags
    loggedInUser.permissions.clear(); // Clear previous permissions
    myRole = ""; // Reset role

    if (loggedInUser.id > 0) {
      // Fetch permissions associated with the user/role
      List<MyPermission> userPermissions = await MyPermission.get_items(); // Adjust if needs user ID filter
      for (var element in userPermissions) {
        // Make slug comparison safer (case-insensitive, null check)
        String slugLower = element.slug.toLowerCase() ?? '';
        if (slugLower == 'canmanagefarmers') {
          canManageFarmers = true;
        }
        if (slugLower == 'cananswerquestions') {
          canAnswerQuestions = true;
        }
        loggedInUser.permissions.add(element.slug);
            }

      // Fetch user's roles
      List<MyRole> myRoles = await MyRole.get_items(); // Adjust if needs user ID filter
      if (myRoles.isNotEmpty) {
        myRole = myRoles[0].role_name ?? ""; // Handle potential null role name
      }
    }

    userModel = loggedInUser; // Update userModel as well
    update(); // Notify listeners of user data change
    return;
  }

  var raw; // Consider giving 'raw' a more specific type if possible (Map<String, dynamic>?)

  getWeather(String lati, String long) async {
    // Basic validation for latitude and longitude
    if (lati.isEmpty || long.isEmpty) {
      print("Error: Latitude or Longitude is empty.");
      return;
    }

    try {
      raw = await Utils.http_get(
          'https://api.open-meteo.com/v1/forecast?latitude=$lati&longitude=$long&hourly=temperature_2m',
          {},
          addBase: false);

      // Check if the response is a Map and contains expected keys
      if (raw is! Map<String, dynamic> || raw['hourly']?['time'] == null || raw['hourly']?['temperature_2m'] == null) {
        print("Error: Invalid weather API response format.");
        print("Received: $raw");
        weatherItems.clear();
        weatherItem.clear();
        update();
        return;
      }

      final hourlyData = raw['hourly'];
      final times = hourlyData['time'] as List?;
      final temperatures = hourlyData['temperature_2m'] as List?;

      if (times == null || temperatures == null || times.length != temperatures.length) {
        print("Error: Weather data mismatch (times/temperatures).");
        weatherItems.clear();
        weatherItem.clear();
        update();
        return;
      }


      DateTime now = DateTime.now();
      List<WeatherItem> tempWeatherItems = [];
      List<WeatherItem> tempWeatherItem = []; // For current hour

      for (int i = 0; i < times.length; i++) {
        try {
          DateTime time = DateTime.parse(times[i].toString());
          WeatherItem item = WeatherItem();
          item.weather = temperatures[i]?.toString() ?? 'N/A'; // Handle potential null temp
          item.time = times[i].toString();

          // Check for current hour's weather
          if (time.year == now.year && time.month == now.month && time.day == now.day && time.hour == now.hour) {
            tempWeatherItem.add(item);
          }

          // Add future weather items
          if (time.isAfter(now) || (time.year == now.year && time.month == now.month && time.day == now.day && time.hour == now.hour)) {
            // Include current hour in the forecast list as well
            tempWeatherItems.add(item);
          }

        } catch (e) {
          print("Error parsing weather data at index $i: $e");
          // Continue processing other items
        }
      }

      // Update reactive lists
      weatherItems.assignAll(tempWeatherItems);
      weatherItem.assignAll(tempWeatherItem);


    } catch (e) {
      print("Error fetching weather data: $e");
      weatherItems.clear();
      weatherItem.clear();
    } finally {
      update(); // Ensure UI updates regardless of success/failure
    }
  }
}