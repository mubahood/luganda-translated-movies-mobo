import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';

import '../../models/CropModel.dart';

class CropPickerScreen extends StatefulWidget {
  CropModel selected = CropModel();

  CropPickerScreen(this.selected, {super.key});

  @override
  State<CropPickerScreen> createState() => _CropPickerScreenState();
}

class _CropPickerScreenState extends State<CropPickerScreen> {
  List<CropModel> items = [];

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
    items = await CropModel.get_items();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleMedium(
                "Select crop",
                fontWeight: 800,
                color: Colors.white,
              ),
            ],
          ),
          backgroundColor: CustomTheme.primary,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: get_items,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: widget.selected.id.toString() ==
                              items[index].id.toString()
                          ? const Icon(
                              Icons.check_circle,
                              color: CustomTheme.primary,
                            )
                          : const Icon(Icons.circle_outlined),
                      onTap: () {
                        //pop with items[index]
                        widget.selected = items[index];
                        //pop with items[index]
                        Navigator.pop(context, widget.selected);

                        setState(() {});
                      },
                      title: Text(items[index].name),
                    );
                  },
                  itemCount: items.length,
                ),
              ));
  }
}
