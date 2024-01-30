import 'package:flutter/material.dart';
import 'package:flutx/widgets/container/container.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';
import 'package:omulimisa2/utils/Utilities.dart';

import '../../models/TrainingCompletedModel.dart';
import '../../models/TrainingSessionLocalModel.dart';
import 'TrainingSessionCreateHomeScreen.dart';
import 'TrainingSessionScreen.dart';

class TrainingSessionsScreen extends StatefulWidget {
  const TrainingSessionsScreen({super.key});

  @override
  State<TrainingSessionsScreen> createState() => _TrainingSessionsScreenState();
}

class _TrainingSessionsScreenState extends State<TrainingSessionsScreen> {
  List<TrainingCompletedModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_items();
  }

  bool isLoading = false;

  Future<void> get_items() async {
    setState(() {
      isLoading = true;
    });
    items = await TrainingCompletedModel.get_items();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Training Sessions"),
          backgroundColor: CustomTheme.primary,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Get.to(() =>
                TrainingSessionCreateHomeScreen(TrainingSessionLocalModel()));

            setState(() {
              isLoading = true;
            });
            await TrainingCompletedModel.getOnlineItems();
            setState(() {
              isLoading = false;
            });
            get_items();
          },
          child: const Icon(Icons.add),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: get_items,
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    TrainingCompletedModel item = items[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FxContainer(
                          onTap: () {
                            Get.to(() => TrainingSessionScreen(item));
                          },
                          borderRadiusAll: 0,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FxText.bodySmall(
                                Utils.to_date_1(item.created_at),
                                color: Colors.black,
                              ),
                              FxText.bodyLarge(
                                item.training_text,
                                color: Colors.black,
                                fontWeight: 600,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  FxText.bodySmall(
                                    item.location_text,
                                    color: Colors.black,
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.black,
                                    size: 14,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  FxText.bodySmall(
                                    Utils.to_date_3(item.created_at),
                                    color: Colors.black,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  },
                  itemCount: items.length,
                ),
              ));
  }
}
