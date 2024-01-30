import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/controllers/MainController.dart';
import 'package:omulimisa2/utils/Utilities.dart';

import '../../models/FarmerQuestion.dart';
import '../../utils/AppConfig.dart';
import '../../utils/my_colors.dart';
import '../../widget/widgets.dart';
import 'FarmerQuestionCreateScreen.dart';
import 'FarmerQuestionScreen.dart';

class FarmerQuestionsScreen extends StatefulWidget {
  const FarmerQuestionsScreen({super.key});

  @override
  FarmerQuestionsScreenState createState() => FarmerQuestionsScreenState();
}

final MainController mainController = Get.find<MainController>();

class FarmerQuestionsScreenState extends State<FarmerQuestionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScreen();
  }

  Future<void> initScreen() async {
    prepareData();
  }

  List<FarmerQuestion> allQuestions = [];
  List<FarmerQuestion> myQuestions = [];
  List<FarmerQuestion> answeredQuestions = [];
  List<FarmerQuestion> notAnsweredQuestions = [];

  Future<void> prepareData() async {
    allQuestions = await mainController.getQuestions();

    myQuestions = [];
    answeredQuestions = [];
    notAnsweredQuestions = [];

    for (var element in allQuestions) {
      if (Utils.int_parse(element.answers_count) > 0) {
        answeredQuestions.add(element);
      } else {
        notAnsweredQuestions.add(element);
      }
      if (element.user_id.toString() ==
          mainController.loggedInUser.id.toString()) {
        myQuestions.add(element);
      }
    }
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
          label: FxText.titleLarge('ASK A QUESTION',
              color: Colors.white, fontWeight: 800),
        ),
        appBar: AppBar(
            toolbarHeight: 40,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: MyColors.primary,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(FeatherIcons.chevronLeft),
            ),
            title: const Text('Farmer Questions',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            actions: const <Widget>[]),
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: MyColors.primary.withOpacity(0.1),
            appBar: AppBar(
              backgroundColor: MyColors.primary,
              automaticallyImplyLeading: false,
              toolbarHeight: 35,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*-------------- Build Tabs here ------------------*/
                  TabBar(
                    padding: const EdgeInsets.only(bottom: 0),
                    labelPadding:
                        const EdgeInsets.only(bottom: 0, left: 10, right: 10, top: 0),
                    isScrollable: true,
                    enableFeedback: true,
                    indicatorPadding: const EdgeInsets.all(0),
                    indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(color: Colors.white, width: 4)),
                    tabs: [
                      Tab(
                          height: 30,
                          child: FxText.titleMedium(
                            "All",
                            fontWeight: 600,
                            color: Colors.white,
                          )),
                      Tab(
                          height: 30,
                          child: FxText.titleMedium("Answered",
                              fontWeight: 600, color: Colors.white)),
                      Tab(
                          height: 30,
                          child: FxText.titleMedium("Unanswered",
                              fontWeight: 600, color: Colors.white)),
                      Tab(
                          height: 30,
                          child: FxText.titleMedium("My Questions",
                              fontWeight: 600, color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
            /*--------------- Build Tab body here -------------------*/
            body: TabBarView(
              children: <Widget>[
                summaryFragment(allQuestions),
                summaryFragment(answeredQuestions),
                summaryFragment(notAnsweredQuestions),
                summaryFragment(myQuestions),
              ],
            ),
          ),
        ));
  }

  Widget summaryFragment(List<FarmerQuestion> questions) {
    return RefreshIndicator(
      backgroundColor: MyColors.primary,
      color: Colors.white,
      onRefresh: prepareData,
      child: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          FarmerQuestion question = questions[index];
          return FxCard(
              onTap: () {
                Get.to(() => FarmerQuestionScreen(question));
              },
              padding: const EdgeInsets.only(
                bottom: 10,
                top: 10,
              ),
              margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
              color: Colors.white,
              child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: [
                              question.user_photo.isEmpty
                                  ? CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      width: 40,
                                      height: 40,
                                      imageUrl:
                                          "${AppConfig.MAIN_SITE_URL}/storage/${question.user_photo}",
                                      placeholder: (context, url) =>
                                          ShimmerLoadingWidget(),
                                      errorWidget: (context, url, error) =>
                                          const Image(
                                        width: 40,
                                        height: 40,
                                        image: AssetImage(
                                            AppConfig.NO_IMAGE),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/user.jpg'))),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    question.user_text,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Asked on ${Utils.to_date(question.created_at)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        question.user_photo.isEmpty
                            ? const SizedBox()
                            : const SizedBox(
                                height: 15,
                              ),
                        question.audio.isNotEmpty
                            ? Container(
                                padding: const EdgeInsets.only(top: 15, bottom: 15),
                                child: const Image(
                                  image: AssetImage(AppConfig.AUDIO_PHOTO),
                                ),
                              )
                            : question.photo.isEmpty
                                ? const SizedBox()
                                : CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: Get.height / 3.5,
                                    imageUrl:
                                        "${AppConfig.MAIN_SITE_URL}/storage/${question.photo}",
                                    placeholder: (context, url) =>
                                        ShimmerLoadingWidget(),
                                    errorWidget: (context, url, error) => const Image(
                                      width: 60,
                                      height: 60,
                                      image:
                                          AssetImage(AppConfig.NO_IMAGE),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Text(
                            question.body,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FeatherIcons.messageCircle,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${question.answers_count} Answers',
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                FeatherIcons.eye,
                                size: 16,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${question.views} Views',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Read More',
                                  style: TextStyle(
                                      color: MyColors.primary,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ])
                      ])));
        },
      ),
    );
  }
}
