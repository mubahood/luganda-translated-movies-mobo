import 'package:flutter/material.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';

import '../../models/DistrictModel.dart';

class DistrictPickerScreen extends StatefulWidget {
  const DistrictPickerScreen({super.key});

  @override
  State<DistrictPickerScreen> createState() => _DistrictPickerScreenState();
}

class _DistrictPickerScreenState extends State<DistrictPickerScreen> {
  List<DistrictModel> items = [];

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
    items = await DistrictModel.get_items();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Select District"),
          backgroundColor: CustomTheme.primary,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: get_items,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context, items[index]);
                      },
                      title: Text(items[index].name),
                    );
                  },
                  itemCount: items.length,
                ),
              ));
  }
}
