import 'dart:core';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/controllers/MainController.dart';
import 'package:omulimisa2/utils/Utilities.dart';

import '../../models/FarmerQuestion.dart';
import '../../utils/my_colors.dart';
import 'FarmerQuestionCreateScreen.dart';
import 'FarmerQuestionScreen.dart';

class FarmerQuestionsScreenOld extends StatefulWidget {
  const FarmerQuestionsScreenOld({super.key});

  @override
  FarmerQuestionsScreenOldState createState() => FarmerQuestionsScreenOldState();
}

final MainController mainController = Get.find<MainController>();

class FarmerQuestionsScreenOldState extends State<FarmerQuestionsScreenOld> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScreen();
  }

  Future<void> initScreen() async {
    prepareData();
  }

  List<FarmerQuestion> questions = [];

  Future<void> prepareData() async {
    /*Utils.toast2("Swipe left/right to view more questions", is_long: true);*/
    questions = await mainController.getQuestions();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Get.to(() => const FarmerQuestionCreateScreen());
            await initScreen();
          },
          label:  FxText.titleLarge('ASK A QUESTION',color: Colors.white, fontWeight: 800),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: initScreen,
            color: MyColors.primary,
            backgroundColor: Colors.white,
            child: ListView(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [MyColors.primary, MyColors.grey_3],
                      // Specify your gradient colors here
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          top: 25,
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: FxContainer(
                                borderRadiusAll: 100,
                                paddingAll: 5,
                                color: Colors.black.withOpacity(0.5),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            FxText.headlineLarge(
                              "Questions",
                              color: Colors.white,
                              fontWeight: 700,
                            ),
                            // ignore: prefer_const_constructors
                            SizedBox(width: 5),
                            const Icon(
                              FeatherIcons.chevronDown,
                              color: Colors.white,
                              size: 50,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 25,
                          top: 15,
                          right: 25,
                        ),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FxContainer(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              borderRadiusAll: 100,
                              child: FxText.bodyMedium(
                                "All Questions",
                                color: MyColors.primary,
                                fontWeight: 700,
                              ),
                            ),
                            const SizedBox(width: 6),
                            FxText.bodySmall(
                              '(Found ${questions.length} questions)',
                              color: Colors.grey.shade200,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: false,
                          viewportFraction: .8,
                          initialPage: 0,
                          enableInfiniteScroll: false,
                          autoPlayInterval: const Duration(seconds: 10),
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.3,
                          height: Get.height / 1.5,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: questions
                            .map(
                              (item) => InkWell(
                                onTap: () {
                                  Get.to(() => FarmerQuestionScreen(item));
                                },
                                child: FxCard(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                    borderRadiusAll: 15,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: FxContainer(
                                            color:
                                                MyColors.primary.withAlpha(300),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            borderRadiusAll: 100,
                                            child: FxText.bodyMedium(
                                              "Question #${item.id}",
                                              color: Colors.black,
                                              fontWeight: 700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            FxText(
                                              "#${item.category}",
                                              color: Colors.grey.shade600,
                                              fontWeight: 700,
                                              strutStyle: const StrutStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            FxText(
                                              "#${item.district_text}",
                                              color: Colors.grey.shade600,
                                              fontWeight: 700,
                                              strutStyle: const StrutStyle(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FxText(
                                                item.body,
                                                color: Colors.black,
                                                fontWeight: 700,
                                                maxLines: 6,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 30,
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  FxText(
                                                    "${item.answers_count} Answers",
                                                    color: Colors.grey.shade600,
                                                    strutStyle:
                                                        const StrutStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  FxText(
                                                    "${item.views} Views",
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ],
                                              ),
                                              const Divider(
                                                  color: MyColors.primary),
                                              Flex(
                                                direction: Axis.horizontal,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(100),
                                                    ),
                                                    child: Container(
                                                      color: Colors.red,
                                                      child: Image.asset(
                                                        'assets/images/menu_profile.png',
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FxText.bodyLarge(
                                                        "By: ${item.user_text}",
                                                        color: MyColors.primary,
                                                        fontWeight: 700,
                                                        maxLines: 7,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(
                                                        height: 3,
                                                      ),
                                                      FxText.bodySmall(
                                                        "On: ${Utils.to_date_1(item.created_at)}",
                                                        color: Colors
                                                            .grey.shade600,
                                                        fontWeight: 700,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FxContainer(
                        color: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        borderRadiusAll: 100,
                        child: FxText.bodySmall(
                          "Swipe left/right to view more questions",
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
