import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logger/logger.dart';

import '../../../../core/styles.dart';
import '../../../../models/TrainingCompletedModel.dart';
import '../../../../models/TrainingModel.dart';
import '../../../../utils/CustomTheme.dart';
import '../../../../utils/Utilities.dart';

class TrainingSessionsScreen extends StatefulWidget {
  const TrainingSessionsScreen({super.key});

  @override
  State<TrainingSessionsScreen> createState() => _TrainingSessionsScreenState();
}

class _TrainingSessionsScreenState extends State<TrainingSessionsScreen> {
  List<TrainingModel> upcomingTraining = [];
  List<TrainingCompletedModel> completedTrainings = [];
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      printTime: false,
    ),
  );
  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  Future<dynamic> myInit() async {
    upcomingTraining = await TrainingModel.get_items();
    //completedTrainings = await TrainingCompletedModel.get_items();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: FxText.titleLarge(
          'Training Programs',
          color: Colors.white,
        ),
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: CustomTheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(
                    child: LoadingAnimationWidget.threeRotatingDots(
                      color: AppStyles.secondaryColor,
                      size: 30,
                    ),
                  );
                default:
                  return RefreshIndicator(
                    onRefresh: doRefresh,
                    color: CustomTheme.primary,
                    backgroundColor: Colors.white,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxContainer(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, right: 10, left: 10),
                                    margin: const EdgeInsets.only(
                                        top: 12,
                                        bottom: 0,
                                        right: 10,
                                        left: 10),
                                    color: CustomTheme.primary,
                                    borderRadiusAll: 0,
                                    child: FxText.titleMedium(
                                      'Upcoming Training Programs'
                                          .toUpperCase(),
                                      fontSize: 16,
                                      fontWeight: 900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5),
                                    child: Divider(
                                      height: 0,
                                      color: CustomTheme.primary,
                                    ),
                                  )
                                ],
                              );
                            },
                            childCount: 1, // 1000 list items
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final session = upcomingTraining[index];
                              return InkWell(
                                onTap: () async {
                                  //await Get.to(() => TripBookingDetailsScreen(stage));
                                  //my_init();
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 0, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FxContainer(
                                        color: Colors.white,
                                        borderColor: Colors.grey.shade300,
                                        bordered: true,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                FxContainer(
                                                  color: session.status ==
                                                          'Pending'
                                                      ? Colors.orange.shade100
                                                      : session.status ==
                                                              'Ongoing'
                                                          ? Colors
                                                              .green.shade100
                                                          : session.status ==
                                                                  'Conducted'
                                                              ? Colors
                                                                  .red.shade100
                                                              : Colors.grey
                                                                  .shade100,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 4),
                                                  child: FxText.bodySmall(
                                                    color: Colors.black,
                                                    session.status
                                                        .toString()
                                                        .toUpperCase(),
                                                    fontWeight: 800,
                                                  ),
                                                ),
                                                FxText.bodyLarge(
                                                  color: Colors.grey.shade600,
                                                  Utils.to_date_1(
                                                      session.created_at),
                                                  fontWeight: 800,
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            FxText.bodyLarge(
                                              session.name,
                                              fontWeight: 600,
                                            )
                                            /*Row(
                                              children: [
                                                FxText.bodyLarge(
                                                  session.name,
                                                  fontWeight: 600,
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  size: 18,
                                                  color: Colors.grey,
                                                ),
                                                FxText.bodyLarge(
                                                  session.venue,
                                                  fontWeight: 600,
                                                ),
                                              ],
                                            )*/
                                            ,
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  width: 3,
                                                ),
                                                FxText.bodySmall(
                                                  Utils.to_date_3(
                                                      session.created_at),
                                                  fontWeight: 600,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(
                                                  Icons.person,
                                                  size: 14,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                FxText.bodySmall(
                                                  '${session.status} Seats',
                                                  color: Colors.grey,
                                                ),
                                                const Spacer(),
                                                const SizedBox(
                                                  width: 2,
                                                ),
                                                FxText.bodySmall(
                                                  'UGX ${Utils.moneyFormat(session.status)}',
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );

                              return SizedBox(
                                height: 200,
                                child: Card(
                                  elevation: 6.0,
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FxContainer(
                                        color: CustomTheme.primary,
                                        borderRadiusAll: 0,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 10),
                                        child: ListTile(
                                          title: FxText.bodySmall(
                                            session.name,
                                            fontWeight: 800,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FxText.bodySmall(
                                                'Venue: ${session.venue}',
                                                fontWeight: 800,
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                              FxText.bodySmall(
                                                'Date: ${session.date}',
                                                fontWeight: 800,
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                              FxText.bodySmall(
                                                'Time: ${session.time}',
                                                fontWeight: 800,
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            // Handle onTap event if needed
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount:
                                upcomingTraining.length, // 1000 list items
                          ),
                        ),
                        /*  SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxContainer(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, right: 10, left: 10),
                                    margin: const EdgeInsets.only(
                                        top: 12, bottom: 0, right: 10, left: 10),
                                    color: CustomTheme.primary,
                                    borderRadiusAll: 0,
                                    child: FxText.titleMedium(
                                      'completed Training Programs'.toUpperCase(),
                                      fontSize: 16,
                                      fontWeight: 900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5),
                                    child: Divider(
                                      height: 0,
                                      color: CustomTheme.primary,
                                    ),
                                  )
                                ],
                              );
                            },
                            childCount: 1, // 1000 list items
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  TrainingCompletedModel trainingCompleted = completedTrainings[index];

                              return  Card(
                                elevation: 4.0,
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FxContainer(
                                        color: CustomTheme.primary,
                                        borderRadiusAll: 0,
                                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                        child: FxText.bodySmall(
                                          'Session Date: ${trainingCompleted.session_date}',
                                          fontWeight: 800,
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        'Details:',
                                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                      ),

                                      SizedBox(height: 8.0),
                                      SingleChildScrollView(
                                        child: Text(trainingCompleted.details),
                                      ),
                                      SizedBox(height: 16.0),
                                      SizedBox(height: 16.0),
                                      Divider(),
                                      if (trainingCompleted.attendance_list_pictures.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Attendance List Pictures:',
                                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 8.0),

                                              SizedBox(
                                                height: 200.0,
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount:trainingCompleted.attendance_list_pictures.substring(1, trainingCompleted.attendance_list_pictures.length - 1).split(',').toList().length,
                                                  itemBuilder: (context, index) {
                                                    final imageUrlList = trainingCompleted.attendance_list_pictures.substring(1, trainingCompleted.attendance_list_pictures.length - 1).split(',').map((imageUrl) => imageUrl.trim()).toList();
                                                    final imageUrl = imageUrlList[index];


                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.network(
                                                        'https://unified.m-omulimisa.com/storage/$imageUrl',
                                                        height: 150.0,
                                                        width: 150.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      Divider(),
                                      SizedBox(height: 16.0),
                                      if (trainingCompleted.members_pictures.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Members Pictures:',
                                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(height: 8.0),
                                              SizedBox(
                                                height: 200.0,
                                                child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: trainingCompleted.members_pictures.substring(1, trainingCompleted.members_pictures.length - 1).split(',').toList().length,
                                                  itemBuilder: (context, index) {
                                                    final imageUrlList = trainingCompleted.members_pictures.substring(1, trainingCompleted.members_pictures.length - 1).split(',').map((imageUrl) => imageUrl.trim()).toList();
                                                    final imageUrl = imageUrlList[index];
                                                    return Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Image.network(
                                                        'https://unified.m-omulimisa.com/storage/$imageUrl',
                                                        height: 150.0,
                                                        width: 150.0,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),


                                            ],
                                          ),
                                        ),

                                    ],
                                  ),
                                ),
                              );
                            },
                            childCount: completedTrainings.length, // 1000 list items
                          ),
                        ),*/
                      ],
                    ),
                  );
              }
            }),
      ),
    );
  }
}
