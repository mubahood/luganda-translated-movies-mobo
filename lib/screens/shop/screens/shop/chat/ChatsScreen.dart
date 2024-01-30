import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../../../controllers/MainController.dart';
import '../../../../../utils/CustomTheme.dart';
import '../../../../../utils/Utilities.dart';
import '../../../../../widget/widgets.dart';
import '../../../models/ChatHead.dart';
import '../widgets.dart';
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late Future<dynamic> futureInit;

  Future<dynamic> do_refresh() async {
    futureInit = my_init();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    disposed = false;
    futureInit = my_init();
  }

  bool disposed = false;
  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  final MainController mainController = Get.find<MainController>();

  List<ChatHead> chatHeads = [];

  bool listenderIsLoading = false;

  Future<void> startListeners() async {
    if(disposed){
      return;
    }
    if (listenderIsLoading) {
      return;
    }
    listenderIsLoading = true;

    chatHeads = await ChatHead.get_items(mainController.userModel);
    await Future.delayed(const Duration(seconds: 5));
    setState(() {});
    listenderIsLoading = false;
    await startListeners();
  }

  Future<dynamic> my_init() async {
    startListeners();
    setState(() {});
    return "Done";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.overlay(),
        elevation: .5,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const FxContainer(
              width: 10,
              height: 20,
              color: Colors.white,
              borderRadiusAll: 2,
            ),
            FxSpacing.width(8),
            FxText.titleLarge(
              "My Messages",
              fontWeight: 900,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return myListLoaderWidget();
                default:
                  return mainWidget();
              }
            }),
      ),
    );
  }

  Future<dynamic> myInit() async {
    //  await mainController.init();
    await startListeners();
    return "Done";
  }

  Widget mainWidget() {
    return chatHeads.isEmpty
        ? Center(
            child: FxText.titleLarge("You don't have any message."),
          )
        : Container(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: do_refresh,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        ChatHead m = chatHeads[index];
                        return chatHeadUi(m);
                      },
                      childCount: chatHeads.length, // 1000 list items
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
