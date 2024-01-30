import 'package:flutter/material.dart';
import 'package:omulimisa2/models/FarmerModel.dart';
import 'package:omulimisa2/screens/shop/screens/shop/widgets.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';

class FarmerDetailsScreen extends StatefulWidget {
  FarmerModel item;

  FarmerDetailsScreen(this.item, {super.key});

  @override
  State<FarmerDetailsScreen> createState() => _FarmerDetailsScreenState();
}

class _FarmerDetailsScreenState extends State<FarmerDetailsScreen> {
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
          title: const Text("Farmer Details"),
          backgroundColor: CustomTheme.primary,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            title_detail_widget("First name", widget.item.first_name),
            title_detail_widget("Last name", widget.item.last_name),
            title_detail_widget("Phone Number", widget.item.phone),
            title_detail_widget("Group", widget.item.farmer_group_text),

          ],
        ));
  }
}
