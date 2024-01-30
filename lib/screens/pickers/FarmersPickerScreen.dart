import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:omulimisa2/models/FarmerModel.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';

import '../../models/DynamicModel.dart';

class FarmersPickerScreen extends StatefulWidget {
  List<DynamicModel> selected = [];

  FarmersPickerScreen(this.selected, {super.key});

  @override
  State<FarmersPickerScreen> createState() => _FarmersPickerScreenState();
}

class _FarmersPickerScreenState extends State<FarmersPickerScreen> {
  List<FarmerModel> items = [];

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
    items = await FarmerModel.get_items();
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
                "Select Members",
                fontWeight: 800,
                color: Colors.white,
              ),
              FxText.bodyMedium(
                "${widget.selected.length} members selected",
                color: Colors.white,
              ),
            ],
          ),
          backgroundColor: CustomTheme.primary,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: get_items,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            trailing: DynamicModel.inList(
                                    widget.selected, items[index].id.toString())
                                ? const Icon(
                                    Icons.check_circle,
                                    color: CustomTheme.primary,
                                  )
                                : const Icon(Icons.circle_outlined),
                            onTap: () {
                              DynamicModel dynamicModel = DynamicModel();
                              dynamicModel.id = items[index].id.toString();
                              dynamicModel.attribute_1 =
                                  "${items[index].first_name} ${items[index].last_name}";

                              if (DynamicModel.inList(widget.selected,
                                  dynamicModel.id.toString())) {
                                widget.selected = DynamicModel.removeFromList(
                                    widget.selected,
                                    dynamicModel.id.toString());
                              } else {
                                widget.selected.add(dynamicModel);
                              }

                              setState(() {});
                            },
                            subtitle: Text(items[index].phone),
                            title: Text(
                                "${items[index].first_name} ${items[index].last_name}"),
                          );
                        },
                        itemCount: items.length,
                      ),
                    ),
                  ),
                  FxContainer(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: FxButton.block(
                      onPressed: () {
                        Navigator.pop(context, widget.selected);
                      },
                      borderRadiusAll: 0,
                      backgroundColor: CustomTheme.primary,
                      child: FxText.bodyLarge(
                        "DONE PICKING MEMBERS",
                        color: Colors.white,
                        fontWeight: 700,
                      ),
                    ),
                  ),
                ],
              ));
  }
}
