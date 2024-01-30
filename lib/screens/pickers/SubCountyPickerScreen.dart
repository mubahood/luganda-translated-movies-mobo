import 'package:flutter/material.dart';
import 'package:omulimisa2/models/SubcountyModel.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';


class SubCountyPickerScreen extends StatefulWidget {
  int district_id;

  SubCountyPickerScreen(this.district_id, {super.key});

  @override
  State<SubCountyPickerScreen> createState() => _SubCountyPickerScreenState();
}

class _SubCountyPickerScreenState extends State<SubCountyPickerScreen> {
  List<SubcountyModel> items = [];

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
    items = await SubcountyModel.get_items(
        where: "district_id = ${widget.district_id}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Select Sub County"),
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
