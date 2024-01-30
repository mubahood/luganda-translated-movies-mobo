import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/DistrictModel.dart';

import '../../controllers/MainController.dart';
import '../../models/WeatherForeCastModel.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/Utilities.dart';
import '../models/MapLocationModel.dart';
import '../models/ParishModel.dart';
import '../models/SubcountyModel.dart';
import '../utils/AppConfig.dart';
import '../utils/my_colors.dart';
import 'MapPickerScreen.dart';

class WeatherForeCastScreen extends StatefulWidget {
  const WeatherForeCastScreen({Key? key}) : super(key: key);

  @override
  _WeatherForeCastScreenState createState() => _WeatherForeCastScreenState();
}

class _WeatherForeCastScreenState extends State<WeatherForeCastScreen>
    with SingleTickerProviderStateMixin {
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    super.initState();
    mainController.initialized;
    mainController.init();
    doRefresh();
    getLocationsInbackground();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: Text("⌛ Loading..."),
                  );
                default:
                  return mainWidget();
              }
            }),
      ),
    );
  }

  MapLocationModel selected_location = MapLocationModel();
  bool pickerIsOpen = true;
  final _fKey = GlobalKey<FormBuilderState>();

  Widget mainWidget() {
    return pickerIsOpen
        ? FormBuilder(
            key: _fKey,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FxContainer(
                          onTap: () {
                            if (selected_sub_county.name.isEmpty) {
                              Utils.toast(
                                  "Location not selected. Request cancelled.");
                              Get.back();
                              return;
                            }
                            setState(() {
                              pickerIsOpen = false;
                            });
                          },
                          paddingAll: 15,
                          child: const Icon(
                            FeatherIcons.x,
                            size: 35,
                            color: Colors.red,
                          )),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, top: 0, right: 15, bottom: 0),
                    child: Center(
                      child: FxText.titleLarge(
                        'WEATHER FORECAST',
                        fontWeight: 800,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
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
                                label: GetStringUtils("Select District")
                                    .capitalize!,
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
                                label: GetStringUtils("Select Sub-County")
                                    .capitalize!,
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
                                label:
                                    GetStringUtils("Select Parish").capitalize!,
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: FxButton.block(
                          padding: const EdgeInsets.all(20),
                          borderRadiusAll: 12,
                          onPressed: () {
                            if (!_fKey.currentState!.validate()) {
                              Utils.toast('Fix some errors first.',
                                  color: Colors.red.shade700);
                              return;
                            }
                            doRefresh();
                            setState(() {
                              pickerIsOpen = false;
                            });
                          },
                          backgroundColor: CustomTheme.primary,
                          child: FxText.titleLarge(
                            'REQUEST FORECAST',
                            color: Colors.white,
                          )))
                ],
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            /*  ListTile(
                onTap: () {
                   myInit();
                },
                leading: Icon(
                  FeatherIcons.arrowLeft,
                  color: Colors.white,
                ),
                title: FxText.titleLarge(
                  'WEATHER FORECAST',
                  fontWeight: 800,
                  color: Colors.white,
                ),
              ),*/
              Container(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  top: 10,
                  bottom: 15,
                ),
                child: InkWell(
                  onTap: () async {
                    pickerIsOpen = true;
                    setState(() {});
                    return;
                    dynamic x = await Get.to(() => MapPickerScreen(const {}));
                    if (x == null) {
                      return;
                    }

                    if (x.runtimeType.toString() != 'MapLocationModel') {
                      Utils.toast('Invalid location');
                      return;
                    }
                    selected_location = x;
                    futureInit = myInit();
                    setState(() {});
                  },
                  child: Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flex(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: FxText.titleLarge(
                                    selected_sub_county.name.isNotEmpty
                                        ? '${selected_district.name}, ${selected_sub_county.name}, ${selected_parish.name}.'
                                        : 'Select Location',
/*                                    '${selected_location.address}',*/
                                    fontWeight: 900,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                Icon(
                                  FeatherIcons.chevronDown,
                                  color: Colors.grey.shade100,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => FxCard(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    width: double.infinity,
                    borderRadiusAll: 25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image(
                              image: const AssetImage('assets/images/rain.png'),
                              fit: BoxFit.cover,
                              width: (Get.width / 3),
                            ),
                            Expanded(
                              child: FxText.headlineLarge(
                                mainController.weatherItem.isEmpty
                                    ? '--.-'
                                    : '${Utils.replaceAfterDot(mainController.weatherItem.first.weather, '').replaceAll('.', '')}°C',
                                fontWeight: 800,
                                textAlign: TextAlign.end,
                                color: CustomTheme.primary,
                                maxLines: 1,
                                fontSize: 70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        FxText.titleLarge(
                          mainController.weatherItem.isEmpty
                              ? '---/----/-----'
                              : Utils.to_date_2(
                                  mainController.weatherItem.first.time),
                          fontWeight: 400,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          height: 0,
                        ),
                        FxText.titleLarge(
                          mainController.weatherItem.isEmpty
                              ? '---:---'
                              : Utils.to_date_3(
                                  mainController.weatherItem.first.time),
                          fontWeight: 800,
                          color: Colors.black,
                          fontSize: 35,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: RefreshIndicator(
                    onRefresh: doRefresh,
                    color: CustomTheme.primary,
                    backgroundColor: Colors.white,
                    child: Obx(() => CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  WeatherItem w =
                                      mainController.weatherItems[index];
                                  return FxCard(
                                      color: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 15),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FxText.titleMedium(
                                                  Utils.to_date_2(w.time),
                                                  fontWeight: 500,
                                                  color: Colors.grey.shade700,
                                                ),
                                                FxText.titleMedium(
                                                  Utils.to_date_3(w.time),
                                                  fontWeight: 800,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                          ),
                                          FxText.headlineLarge(
                                            '${w.weather}°C',
                                            fontWeight: 800,
                                            color: CustomTheme.primary,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Image(
                                            image: AssetImage(
                                                'assets/images/rain.png'),
                                            fit: BoxFit.cover,
                                            width: 30,
                                          ),
                                        ],
                                      ));
                                },
                                childCount: mainController
                                    .weatherItems.length, // 1000 list items
                              ),
                            ),
                          ],
                        )) /*ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      FxText.bodyLarge(
                        "There are 12 items on this Main Menu. Press on item to select it.",
                        height: 1,
                        fontWeight: 800,
                      ),
                      menuItemWidget(
                          '1. My notifications',
                          'Press here to see your messages and important alerts.',
                          'bell.png',
                          () => {}),
                      menuItemWidget(
                          '2. My persons with disabilities',
                          'Register & Manage people with disabilities.',
                          'form.png',
                          () => {Get.to(() => const PWDList())}),
                      menuItemWidget(
                          '3. Jobs and Opportunities',
                          'Browse job opportunities in Uganda that are suitable for you.',
                          'jobs.png',
                          () => {}),
                      menuItemWidget(
                          '4. Shop',
                          'Buy products and services that can help you in your day-to-day life.',
                          'shop.png',
                          () => {}),
                      menuItemWidget(
                          '5. Counseling services',
                          'Browse, meet and talk counselors across different parts of Uganda.',
                          'counselors.png',
                          () => {}),
                      menuItemWidget(
                          '6. News',
                          'Stay updated with latest news based on persons with disabilities.',
                          'news.png',
                          () => {}),
                      menuItemWidget(
                          '7. Events',
                          'Browse and register for upcoming events that are about to take place.',
                          'events.png',
                          () => {}),
                      menuItemWidget(
                          '8. Institutions',
                          'Press here to see Institutions for person with disabilities near you.',
                          'school.png',
                          () => {}),
                      menuItemWidget(
                          '9. Associations',
                          'United we stand! browse and join  associations that can support you.',
                          'associations.png',
                          () => {}),
                      menuItemWidget(
                          '10. Innovations',
                          'Open here to see different technologies for persons with disabilities and how you can acquire them.',
                          'innovation.png',
                          () => {}),
                      menuItemWidget(
                          '11. Testimonials',
                          'Learn from videos, audios, pictures and articles of people\'s experience.',
                          'testimonial.png',
                          () => {}),
                      menuItemWidget(
                          '12. My Account',
                          'Open here to manage everything your account and content that you post on this platform.',
                          'bell.png',
                          () => {}),
                      FxContainer(
                        margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                        color: Colors.grey.shade200,
                        bordered: true,
                        borderColor: Colors.black,
                        child: FxText.bodyLarge(
                          'End of the menu. Scroll back to top to go through it again.',
                          fontWeight: 800,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ],
              )*/
              ,
            ),
          ),
        ),
      ],
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
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

  Future<dynamic> myInit() async {
    if (isFirst) {
      isFirst = false;
      return "Done";
    }
    if(selected_district.name.isEmpty){
      Utils.toast('Please select a district first.');
      return;
    }
    if(selected_sub_county.name.isEmpty){
      Utils.toast('Please select a location first.');
      return;
    }
    if(selected_parish.name.isEmpty){
      Utils.toast('Please select a parish first.');
      return;
    }
    Utils.toast2('Getting weather forecast...');
    MapLocationModel loc = await Utils.searchWord(
        'Uganda, ${selected_district.name}, ${selected_sub_county.name},  ${selected_parish.name}');
   /* Utils.toast('==>${loc.name}<===');*/

    if (loc.latitude  != 0) {
      selected_location.latitude = loc.latitude;
      selected_location.longitude = loc.longitude;

      selected_location.address = await getLocationName(
          selected_location.latitude, selected_location.longitude);
      selected_location.name = selected_location.address;
    }
    await mainController.getWeather(selected_location.latitude.toString(),
        selected_location.longitude.toString());

    setState(() {});
    return "Done";
  }

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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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
