import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:omulimisa2/models/FarmerModel.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';

class UserPickerScreen extends StatefulWidget {
  FarmerModel selected = FarmerModel();

  UserPickerScreen(this.selected, {super.key});

  @override
  State<UserPickerScreen> createState() => _UserPickerScreenState();
}

class _UserPickerScreenState extends State<UserPickerScreen> {
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
                "Select User",
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
                      title: Text(
                          "${items[index].first_name} ${items[index].last_name}"),
                    );
                  },
                  itemCount: items.length,
                ),
              ));
  }
}
