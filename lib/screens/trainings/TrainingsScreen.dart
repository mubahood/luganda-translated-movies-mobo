import 'package:flutter/material.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';

import '../../models/TrainingModel.dart';
import '../../widget/widgets.dart';

class TrainingsScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  TrainingsScreen(this.params, {super.key});

  @override
  State<TrainingsScreen> createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
  List<TrainingModel> items = [];

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
    items = await TrainingModel.get_items();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Trainings"),
          backgroundColor: CustomTheme.primary,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: get_items,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final session = items[index];
                    return InkWell(
                      onTap: () async {
                        if (widget.params['picker'] == true) {
                          Navigator.pop(context, session);
                        } //await Get.to(() => TripBookingDetailsScreen(stage));
                        //my_init();
                      },
                      child: training_widget(session),
                    );
                  },
                  itemCount: items.length,
                ),
              ));
  }
}
