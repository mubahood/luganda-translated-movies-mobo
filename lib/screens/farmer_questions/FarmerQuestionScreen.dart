import 'dart:async';
import 'dart:core';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/controllers/MainController.dart';
import 'package:omulimisa2/utils/Utilities.dart';

import '../../models/FarmerQuestion.dart';
import '../../models/FarmerQuestionAnswer.dart';
import '../../utils/AppConfig.dart';
import '../../utils/CustomTheme.dart';
import '../../utils/my_colors.dart';
import '../../widget/widgets.dart';
import 'FarmerQuestionAnswerCreateScreen.dart';
import 'VoiceRecordScreen.dart';

class FarmerQuestionScreen extends StatefulWidget {
  FarmerQuestion item;

  FarmerQuestionScreen(this.item, {super.key});

  @override
  FarmerQuestionScreenState createState() => FarmerQuestionScreenState();
}

final MainController mainController = Get.find<MainController>();

class FarmerQuestionScreenState extends State<FarmerQuestionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScreen();
  }

  Future<void> initScreen() async {
    prepareData();
  }

  FarmerQuestion item = FarmerQuestion();
  List<FarmerQuestionAnswer> answers = [];
  StreamSubscription? _playerSubscription;
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  final Codec _codec = Codec.aacMP4;

  Future<void> startPlayer(String url) async {
    try {
      Uint8List? dataBuffer;
      String? audioFilePath;
      var codec = _codec;
      await playerModule.closePlayer();
      await playerModule.openPlayer();
      await playerModule.setSubscriptionDuration(const Duration(milliseconds: 10));

      await playerModule.startPlayer(
          fromURI: url,
          codec: codec,
          sampleRate: tSTREAMSAMPLERATE,
          whenFinished: () {
            playerModule.logger.d('Play finished');
            setState(() {});
          });

      setState(() {});
      playerModule.logger.d('<--- startPlayer');
    } on Exception catch (err) {
      Utils.toast2("FAILED");
      playerModule.logger.e('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      playerModule.logger.d('stopPlayer');
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
    } on Exception catch (err) {
      playerModule.logger.d('error: $err');
    }
    setState(() {});
  }


  Future<void> prepareData() async {
    await mainController.getLoggedInUser();


    item = widget.item;
    answers = await FarmerQuestionAnswer.get_items(
        where: ' farmer_question_id=${item.id} ');

    setState(() {});
  }

/*
*
the transaction object for database operations during a transaction
[        ] I/flutter (24481): Warning database has been locked for 0:00:10.000000. Make sure you always use the transaction object for database operations during a transaction
[   +4 ms] I/flutter (24481): Warning database has been locked for 0:00:10.000000. Make sure you always use the transaction object for database operations during a transaction
[        ] I/flutter (24481): Warning database has been locked for 0:00:10.000000. Make sure you always use the transaction object for database operations during a transaction
[   +6 ms] I/flutter (24481): Warning database has been locked for 0:00:10.000000. Make sure you always use the transaction object for database operations during a transaction
[        ] I/flutter (24481): Warning database has been locked for 0:00:10.000000. Make sure you always use the transaction object for database operations during a transaction
[   +4 ms] I/flutter (24481): Warning database has been locked for 0:00:10.000000. Make sure you always use the transaction object for database operations during a transaction

*
* * */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: !mainController.canAnswerQuestions
            ? null
            : FloatingActionButton.extended(
                onPressed: () async {
                  await Get.to(() => FarmerQuestionAnswerCreateScreen(item));
                  initScreen();
                },
                label: FxText.titleLarge(
                  'ANSWER THIS QUESTION',
                  color: Colors.white,
                  fontWeight: 600,
                ),
              ),
        body: RefreshIndicator(
          onRefresh: initScreen,
          color: MyColors.primary,
          backgroundColor: Colors.white,
          child: Column(
            children: [
              Container(
                height: Get.height,
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
                    const SizedBox(
                      height: 20,
                    ),
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
                            "Question #${item.id}",
                            color: Colors.white,
                            fontWeight: 700,
                            height: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxText.bodyLarge(
                              "By: ${item.user_text}",
                              color: Colors.white,
                              fontWeight: 700,
                              maxLines: 7,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            FxText.bodySmall(
                              "On: ${Utils.to_date_1(item.created_at)}",
                              color: Colors.grey.shade400,
                              fontWeight: 700,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
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
                          width: 25,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Expanded(
                        child: CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return FxContainer(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 25,
                                    top: 25,
                                    right: 25,
                                    bottom: 25,
                                  ),
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
                                        fontSize: 25,
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
                                      widget.item.photo.isEmpty
                                          ? const SizedBox()
                                          : CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              width: Get.width,
                                              imageUrl:
                                                  "${AppConfig.MAIN_SITE_URL}/storage/${widget.item.photo}",
                                              placeholder: (context, url) =>
                                                  ShimmerLoadingWidget(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Image(
                                                image: AssetImage(
                                                    AppConfig.NO_IMAGE),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      widget.item.audio.length < 3
                                          ? const SizedBox()
                                          : FxContainer(
                                              margin: const EdgeInsets.only(
                                                top: 25,
                                              ),
                                              bordered: true,
                                              borderColor: Colors.grey.shade600,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      if (!playerModule
                                                          .isPlaying) {
                                                        startPlayer(
                                                            '${AppConfig.MAIN_SITE_URL}/storage/${widget.item
                                                                    .audio}');
                                                      } else {
                                                        stopPlayer();
                                                      }
                                                    },
                                                    child: Icon(
                                                      !playerModule.isPlaying
                                                          ? FeatherIcons.play
                                                          : FeatherIcons
                                                              .stopCircle,
                                                      size: 50,
                                                      color: !playerModule
                                                              .isPlaying
                                                          ? CustomTheme.primary
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  FxText.titleLarge(
                                                    !playerModule.isPlaying
                                                        ? "PLAY\nAUDIO"
                                                        : "STOP\nRPLAYING",
                                                    fontWeight: 700,
                                                    color: Colors.black,
                                                    textAlign: TextAlign.center,
                                                    height: 1,
                                                  ),
                                                ],
                                              ),
                                            ),

/*                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FxText(
                                            "${item.answers_count} Answers",
                                            color: Colors.grey.shade600,
                                            strutStyle: const StrutStyle(
                                              fontStyle: FontStyle.italic,
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
                                      ),*/
                                    ],
                                  ));
                            },
                            childCount: 1, // 1000 list items
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              var answer = answers[index];
                              return FxContainer(
                                paddingAll: 0,
                                bordered: false,
                                padding: const EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        FxText.bodyMedium(
                                          "Answer #${answer.id}",
                                          color: Colors.grey.shade600,
                                        ),
                                        FxText.bodyMedium(
                                          "On: ${Utils.to_date(answer.created_at)}",
                                          color: Colors.grey.shade600,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    FxText.bodyLarge(
                                      answer.body,
                                      color: Colors.grey.shade800,
                                      fontWeight: 600,
                                      height: 1,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        answer.verified == 'yes'
                                            ? const Icon(
                                                Icons.check,
                                                color: MyColors.primary,
                                                size: 20,
                                              )
                                            : Container(),
                                        Expanded(
                                          child: FxText.bodyMedium(
                                            "Answer By: ${answer.user_text}",
                                            color: MyColors.primary,
                                            fontWeight: 800,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                      height: 0,
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: answers.length, // 1000 list items
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                height: 100,
                                color: Colors.white,
                              );
                            },
                            childCount: 1, // 1000 list items
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
