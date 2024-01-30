import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/FarmerModel.dart';
import 'package:omulimisa2/screens/farmer_profiling/FarmerProfilingStep1Screen.dart';
import 'package:omulimisa2/utils/Utilities.dart';

import '../../models/FarmerGroupModel.dart';
import '../../utils/CustomTheme.dart';
import 'FarmerDetailsScreen.dart';

class FarmersListScreen extends StatefulWidget {
  FarmerGroupModel group;

  FarmersListScreen(this.group, {Key? key}) : super(key: key);

  @override
  _FarmersListScreenState createState() => _FarmersListScreenState();
}

class _FarmersListScreenState extends State<FarmersListScreen>
    with SingleTickerProviderStateMixin {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();

    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        actions: [
          /*IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),*/
          IconButton(
            onPressed: () {
              Get.to(() => FarmerProfilingStep1Screen(widget.group));
            },
            icon: const Icon(
              Icons.add,
              size: 35,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        title: FxText.titleLarge(
          "${widget.group.name} - Farmers",
          color: Colors.white,
          maxLines: 2,
          fontWeight: 700,
        ),
      ),
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

  Widget mainWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: doRefresh,
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 10),
                        child: FxText.bodyLarge(
                          "Found ${items.length} registered farmers.",
                          height: 1,
                          fontWeight: 800,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  );
                },
                childCount: 1, // 1000 list items
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  FarmerModel m = items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => {Get.to(() => FarmerDetailsScreen(m))},
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset:
                                  const Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: CustomTheme.primary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: FxText.bodySmall(
                                  m.first_name.substring(0, 1).toUpperCase(),
                                  fontWeight: 700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxText.bodyLarge(
                                    "${m.first_name} ${m.last_name}",
                                    fontWeight: 700,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  FxContainer(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    color: m.gender.toLowerCase().contains("f")
                                        ? Colors.pink
                                        : Colors.blue,
                                    child: FxText.bodySmall(
                                      m.gender,
                                      fontWeight: 700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                FxText.bodyMedium(
                                  "Registered",
                                  fontWeight: 700,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FxText.bodyMedium(
                                  Utils.to_date_1(m.created_at),
                                  fontWeight: 700,
                                  color: Colors.grey.shade700,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: items.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  List<FarmerModel> items = [];

  Future<dynamic> myInit() async {
    items = await FarmerModel.get_items();
    setState(() {});
    return "Done";
  }
}
