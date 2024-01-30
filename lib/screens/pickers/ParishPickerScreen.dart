import 'package:flutter/material.dart';
import 'package:omulimisa2/models/ParishModel.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';


class ParishPickerScreen extends StatefulWidget {
  int subcounty_id;

  ParishPickerScreen(this.subcounty_id, {super.key});

  @override
  State<ParishPickerScreen> createState() => _ParishPickerScreenState();
}

class _ParishPickerScreenState extends State<ParishPickerScreen> {
  List<ParishModel> items = [];

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
    items = await ParishModel.get_items(
        where: "subcounty_id = ${widget.subcounty_id}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Select Parish"),
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
