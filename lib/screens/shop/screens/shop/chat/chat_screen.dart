import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../../controllers/MainController.dart';
import '../../../../../models/RespondModel.dart';
import '../../../../../utils/CustomTheme.dart';
import '../../../../../utils/Utilities.dart';
import '../../../../../utils/app_theme.dart';
import '../../../models/ChatHead.dart';
import '../../../models/ChatMessage.dart';
import '../../../models/Product.dart';

class ChatScreen extends StatefulWidget {
  ChatHead chatHead;
  Product product;

  ChatScreen(this.chatHead, this.product, {super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late CustomTheme customTheme;
  late ThemeData theme;
  bool isExpanded = false, showMenu = false;

  ScrollController? _scrollController;
  TextEditingController? _chatTextController;

  final List<String> _simpleChoice = ["Create shortcut", "Clear chat"];
  List<ChatMessage> _chatList = [];
  final List<Timer> _timers = [];

  bool isChatTextEmpty = true;

  @override
  void initState() {
    super.initState();
    disposed = false;
    if ((widget.chatHead.id < 1) && widget.product.id < 1) {
      Utils.toast("Chat head not found.");
      Get.back();
      return;
    }

    doRefresh();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    _chatTextController = TextEditingController();
    _scrollController = ScrollController();
  }

  int customer_id = 0;
  int product_owner_id = 0;
  final MainController mainController = Get.find<MainController>();

  Future<void> myInit() async {
    if (widget.chatHead.id < 1 && widget.product.id < 1) {
      Utils.toast("Chat head not found.");
      Get.back();
      return;
    }

    if (widget.chatHead.id < 1) {
      if (Utils.int_parse(widget.product.user) == mainController.userModel.id) {
        product_owner_id = mainController.userModel.id;
        customer_id = Utils.int_parse(widget.product.user);
      } else {
        customer_id = mainController.userModel.id;
        product_owner_id = Utils.int_parse(widget.product.user);
      }

      List<ChatHead> localChats = await ChatHead.get_items(
        mainController.userModel,
        where:
            'product_id = ${widget.product.id} AND customer_id = $customer_id AND product_owner_id = $product_owner_id',
      );
      if (localChats.isNotEmpty) {
        widget.chatHead = localChats.first;
      } else {
        localChats = await ChatHead.get_items(
          mainController.userModel,
          where:
              'product_id = ${widget.product.id} AND product_owner_id = $customer_id AND customer_id = $product_owner_id',
        );
        if (localChats.isNotEmpty) {
          widget.chatHead = localChats.first;
        }
      }
    }

    if (widget.chatHead.id < 1) {
      await startChart();
    }
    setState(() {});
    if (widget.chatHead.id < 1) {
      Utils.toast2("Failed to start chat. Please try again.");
      Get.back();
      return;
    }
    _chatList = await ChatMessage.get_items(mainController.userModel,
        where: ' chat_head_id = ${widget.chatHead.id} ');
    _chatList.sort((b, a) => b.id.compareTo(a.id));

    setState(() {});

    _chatTextController!.addListener(() {
      setState(() {
        isChatTextEmpty = _chatTextController!.text.isEmpty;
      });
    });
    markAasRead();
    startListener();
    setState(() {});
  }

  bool listenerIsLoading = false;

  markAasRead() async {
    RespondModel resp =
    RespondModel(await Utils.http_post('chat-mark-as-read', {
      'receiver_id': mainController.userModel.id,
      'chat_head_id': widget.chatHead.id,
    }));
  }

  startListener() async {
    if (disposed) {
      return;
    }
    if (listenerIsLoading) {
      return;
    }
    listenerIsLoading = true;
    await ChatMessage.getOnlineItems(mainController.userModel,
        params: {'chat_head_id': widget.chatHead.id, 'doDeleteAll': true});

    List<ChatMessage> tempMessages = await ChatMessage.getLocalData(
        mainController.userModel,
        where: ' chat_head_id = ${widget.chatHead.id} ');

    bool newMsg = false;
    List<int> ids = [];
    for (var element in _chatList) {
      ids.add(element.id);
    }
    for (var element in tempMessages) {
      if (element.sender_id.toString() !=
          mainController.userModel.id.toString()) {
        if (!ids.contains(element.id)) {
          _chatList.add(element);
          newMsg = true;
        }
      }
    }

    if (newMsg) {
      setState(() {});
      scrollToBottom(isDelayed: true);
    }
    listenerIsLoading = false;
    await Future.delayed(const Duration(seconds: 5));
    startListener();
  }

  bool disposed = false;

  @override
  void dispose() {
    super.dispose();
    disposed = true;
    _scrollController!.dispose();
    for (Timer timer in _timers) {
      timer.cancel();
    }
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: doRefresh,
      color: CustomTheme.primary,
      backgroundColor: Colors.white,
      child: Container(
        padding: FxSpacing.top(FxSpacing.safeAreaTop(context)),
        child: Column(
          children: [
            Container(
              child: appBarWidget(),
            ),
            FutureBuilder(
                future: futureInit,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("⌛ Loading..."),
                    );
                  }
                  return Expanded(
                      child: Container(
                    margin: FxSpacing.horizontal(16),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: FxSpacing.zero,
                      itemCount: _chatList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: index == 0
                              ? FxSpacing.only(top: 12, bottom: 6).add(
                                  _chatList[index].sender_id.compareTo(mainController.userModel.id.toString()) == 0
                                      ? EdgeInsets.only(
                                          left: MediaQuery.of(context).size.width *
                                              0.2)
                                      : EdgeInsets.only(
                                          right: MediaQuery.of(context).size.width *
                                              0.2))
                              : FxSpacing.only(top: 6, bottom: 6).add(
                                  _chatList[index].isMyMessage
                                      ? EdgeInsets.only(
                                          left: MediaQuery.of(context).size.width * 0.2)
                                      : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.2)),
                          alignment: _chatList[index].isMyMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: singleChat(index),
                        );
                      },
                    ),
                  ));
                }),
            Container(
              child: bottomBarWidget(),
            )
          ],
        ),
      ),
    ));
  }

  Widget appBarWidget() {
    return FxContainer(
      padding: FxSpacing.fromLTRB(16, 4, 4, 4),
      color: theme.scaffoldBackgroundColor,
      child: Flex(
        direction: Axis.horizontal,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              MdiIcons.chevronLeft,
              color: theme.colorScheme.onBackground,
            ),
          ),
          Container(
            margin: FxSpacing.left(8),
            child: const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                image: AssetImage('./assets/images/logo_1.png'),
                width: 32,
                height: 32,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: FxSpacing.left(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FxText.bodyLarge(widget.chatHead.product_name,
                      color: theme.colorScheme.onBackground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: 600),
                  FxText.bodySmall(widget.chatHead.product_owner_name,
                      color: theme.colorScheme.onBackground,
                      muted: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: 600),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      startChart();
                    },
                    child: Container(
                      padding: FxSpacing.all(4),
                      child: InkWell(
                        onTap: () {
                          doRefresh();
                        },
                        child: Icon(
                          MdiIcons.refresh,
                          color: theme.colorScheme.onBackground,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
/*                  InkWell(
                    onTap: () {
                      startChart();

                    },
                    child: Container(
                      margin: FxSpacing.left(8),
                      padding: FxSpacing.all(4),
                      child: Icon(
                        MdiIcons.videoOutline,
                        color: theme.colorScheme.onBackground,
                        size: 22,
                      ),
                    ),
                  ),*/
                  Container(
                    margin: FxSpacing.left(4),
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return _simpleChoice.map((String choice) {
                          return PopupMenuItem(
                            value: choice,
                            child: FxText.bodyMedium(choice,
                                letterSpacing: 0.15,
                                color: theme.colorScheme.onBackground),
                          );
                        }).toList();
                      },
                      color: customTheme.card,
                      icon: Icon(
                        MdiIcons.dotsVertical,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomBarWidget() {
    return FxContainer(
      padding: FxSpacing.fromLTRB(24, 12, 24, 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        onEnd: () {
          setState(() {
            showMenu = isExpanded;
          });
        },
        height: isExpanded ? 124 : 42,
        child: ListView(
          padding: FxSpacing.zero,
          children: [
            Row(
              children: [
                FxContainer.rounded(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      if (!showMenu) showMenu = true;
                    });
                  },
                  padding: FxSpacing.all(8),
                  color: theme.colorScheme.primary.withAlpha(28),
                  child: Icon(
                    MdiIcons.plus,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: FxSpacing.left(16),
                    child: TextFormField(
                      style: FxTextStyle.bodyMedium(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: 500),
                      decoration: InputDecoration(
                        hintText: "Type here",
                        hintStyle: FxTextStyle.bodyMedium(
                            letterSpacing: 0.1,
                            color: theme.colorScheme.onBackground,
                            muted: true,
                            fontWeight: 500),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            borderSide: BorderSide(
                                color: customTheme.border, width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            borderSide: BorderSide(
                                color: customTheme.border, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            borderSide: BorderSide(
                                color: customTheme.border, width: 1)),
                        isDense: true,
                        contentPadding: FxSpacing.fromLTRB(16, 12, 16, 12),
                        filled: true,
                        fillColor: customTheme.card,
                      ),
                      textInputAction: TextInputAction.send,
                      onFieldSubmitted: (message) {
                        sendMessage(message);
                      },
                      controller: _chatTextController,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                ),
                FxContainer.rounded(
                  margin: FxSpacing.left(16),
                  width: 38,
                  onTap: () {
                    sendMessage(_chatTextController!.text);
                  },
                  height: 38,
                  padding: FxSpacing.left(isChatTextEmpty ? 0 : 4),
                  color: theme.colorScheme.primary.withAlpha(28),
                  child: Icon(
                    isChatTextEmpty
                        ? MdiIcons.microphoneOutline
                        : MdiIcons.sendOutline,
                    color: theme.colorScheme.primary,
                    size: isChatTextEmpty ? 20 : 18,
                  ),
                )
              ],
            ),
            showMenu
                ? Container(
                    margin: FxSpacing.top(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        optionWidget(
                            color: Colors.blue,
                            iconData: MdiIcons.imageOutline,
                            title: "Image"),
                        optionWidget(
                            color: Colors.pink,
                            iconData: MdiIcons.mapMarkerOutline,
                            title: "Location"),
                        optionWidget(
                            color: Colors.orange,
                            iconData: MdiIcons.accountOutline,
                            title: "Contact"),
                        optionWidget(
                            color: Colors.purple,
                            iconData: MdiIcons.fileDocumentOutline,
                            title: "File"),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget optionWidget(
      {IconData? iconData, required Color color, String title = ""}) {
    return Column(
      children: [
        Container(
          padding: FxSpacing.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withAlpha(40),
          ),
          child: Icon(
            iconData,
            color: color,
            size: 22,
          ),
        ),
        Container(
          margin: FxSpacing.top(4),
          child: FxText.bodySmall(title,
              fontSize: 12,
              color: theme.colorScheme.onBackground,
              fontWeight: 600),
        )
      ],
    );
  }

  Widget singleChat(int index) {
    if (_chatList[index].isMyMessage) {
      return Container(
          padding: FxSpacing.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            border: Border.all(color: customTheme.border, width: 1),
            borderRadius: makeChatBubble(index),
          ),
          child: FxText.titleSmall(
            _chatList[index].body,
            color: _chatList[index].status == "seen"
                ? theme.colorScheme.onBackground
                : theme.colorScheme.onBackground.withAlpha(150),
            letterSpacing: 0.1,
            fontWeight: _chatList[index].status == "seen" ? 500 : 600,
            overflow: TextOverflow.fade,
          ));
    } else {
      return Container(
          padding: FxSpacing.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: const Color(0xff4d7af7),
            borderRadius: makeChatBubble(index),
          ),
          child: FxText.titleSmall(
            _chatList[index].body,
            color: theme.colorScheme.onPrimary,
            letterSpacing: 0.1,
            overflow: TextOverflow.fade,
          ));
    }
  }

  BorderRadius makeChatBubble(int index) {
    if (_chatList[index].isMyMessage) {
      if (index != 0) {
        if (_chatList[index - 1].isMyMessage) {
          return const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4));
        } else {
          return const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(0));
        }
      } else {
        return const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
            topRight: Radius.circular(0));
      }
    } else {
      if (index != 0) {
        if (_chatList[index - 1].isMyMessage) {
          return const BorderRadius.only(
              topLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4));
        } else {
          return const BorderRadius.only(
              topLeft: Radius.circular(0),
              bottomRight: Radius.circular(4),
              bottomLeft: Radius.circular(4),
              topRight: Radius.circular(4));
        }
      } else {
        return const BorderRadius.only(
            topLeft: Radius.circular(0),
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
            topRight: Radius.circular(4));
      }
    }
  }

  String getStringTimeFromMilliseconds(String timestamp) {
    try {
      int time = int.parse(timestamp);
      var date = DateTime.fromMillisecondsSinceEpoch(time);
      int hour = date.hour, min = date.minute;
      if (hour > 12) {
        if (min < 10) {
          return "${hour - 12}:0$min pm";
        } else {
          return "${hour - 12}:$min pm";
        }
      } else {
        if (min < 10) {
          return "$hour:0$min am";
        } else {
          return "$hour:$min am";
        }
      }
    } catch (e) {
      return "";
    }
  }

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) {
      Utils.toast("Message can't be empty");
      return;
    }
    if (message.isNotEmpty) {
      ChatMessage msg = ChatMessage();
      msg.body = message;
      msg.created_at = DateTime.now().toIso8601String();
      msg.updated_at = DateTime.now().toIso8601String();
      msg.chat_head_id = widget.chatHead.id.toString();
      msg.product_id = widget.chatHead.product_id.toString();
      msg.sender_id = mainController.userModel.id.toString();
      msg.sender_text = mainController.userModel.name.toString();
      msg.sender_name = mainController.userModel.name.toString();
      msg.type = 'text'.toString();
      msg.status = 'unsent'.toString();
      msg.isMyMessage = true;

      if (mainController.userModel.id.toString() !=
          widget.chatHead.product_owner_id.toString()) {
        msg.receiver_text = widget.chatHead.product_owner_name.toString();
        msg.receiver_id = widget.chatHead.product_owner_id.toString();
      } else {
        msg.receiver_text = widget.chatHead.customer_name.toString();
        msg.receiver_id = widget.chatHead.customer_id.toString();
      }

      setState(() {
        _chatTextController!.clear();
        _chatList.add(msg);
        startTimer(_chatList.length - 1, message);
      });

      scrollToBottom(isDelayed: true);

      await msg.save();
      String r = await msg.uploadSelf(mainController.userModel);
      if (r.isEmpty) {
      } else {
        Utils.toast('FAILED: $r');
      }
    }
  }

  void startTimer(int index, String message) {
    const twoSec = Duration(seconds: 2);
    const threeSec = Duration(seconds: 3);

    Timer timerSeen = Timer.periodic(
        twoSec,
        (Timer timer) => {
              timer.cancel(),
              setState(() {
                _chatList[index].type = "seen";
              })
            });
    _timers.add(timerSeen);
    Timer timer = Timer.periodic(
        threeSec, (Timer timer) => {timer.cancel(), sentFromOther(message)});
    _timers.add(timer);
  }

  void sentFromOther(String message) {
    /*setState(() {
      _chatList.add(ChatModel(message, ChatModel.otherId,
          DateTime
              .now()
              .millisecondsSinceEpoch
              .toString(), "sent"));
      scrollToBottom(isDelayed: true);
    });*/
  }

  scrollToBottom({bool isDelayed = false}) {
    final int delay = isDelayed ? 400 : 0;
    Future.delayed(Duration(milliseconds: delay), () {
      _scrollController!.animateTo(_scrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  int receiver_id = 0;
  int sender_id = 0;

  Future<void> startChart() async {
    Utils.toast2("Please wait...", is_long: true);
    if (!await Utils.is_connected()) {
      Utils.toast2("No internet connection");
      return;
    }
    if (mainController.userModel.id != widget.product.id) {
      receiver_id = Utils.int_parse(widget.product.user);
      sender_id = mainController.userModel.id;
    } else {
      receiver_id = mainController.userModel.id;
      sender_id = Utils.int_parse(widget.product.user);
    }
    RespondModel resp = RespondModel(await Utils.http_post('chat-start', {
      'sender_id': sender_id,
      'receiver_id': receiver_id,
      'product_id': widget.product.id,
    }));

    if (resp.code != 1) {
      Utils.toast2(resp.message);
      return;
    }

    widget.chatHead = ChatHead.fromJson(resp.data);
    await widget.chatHead.save();
    setState(() {});
    return;
  }
}
