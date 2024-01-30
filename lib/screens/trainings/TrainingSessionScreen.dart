import 'package:flutter/material.dart';
import 'package:omulimisa2/screens/shop/screens/shop/widgets.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';
import 'package:omulimisa2/utils/Utilities.dart';

import '../../models/TrainingCompletedModel.dart';

class TrainingSessionScreen extends StatefulWidget {
  TrainingCompletedModel item;

  TrainingSessionScreen(this.item, {super.key});

  @override
  State<TrainingSessionScreen> createState() => _TrainingSessionScreenState();
}

class _TrainingSessionScreenState extends State<TrainingSessionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Training Session Details"),
          backgroundColor: CustomTheme.primary,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            title_detail_widget("Training", widget.item.training_text),
            title_detail_widget(
                "Date", Utils.to_date_1(widget.item.created_at)),
            title_detail_widget(
                "Time", Utils.to_date_3(widget.item.created_at)),
            title_detail_widget("Venue", widget.item.location_text),
            title_detail_widget("Trainer", widget.item.conducted_by),
            title_detail_widget("Participants", widget.item.id.toString()),
          ],
        ));
  }
}
