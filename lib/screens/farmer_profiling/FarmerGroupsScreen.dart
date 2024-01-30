import 'package:flutter/material.dart';
import 'package:flutx/widgets/card/card.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:omulimisa2/screens/farmer_profiling/FarmersListScreen.dart';
import 'package:omulimisa2/utils/AppConfig.dart';
import 'package:omulimisa2/utils/CustomTheme.dart';

import '../../models/FarmerGroupModel.dart';

class FarmerGroupsScreen extends StatefulWidget {
  const FarmerGroupsScreen({super.key});

  @override
  State<FarmerGroupsScreen> createState() => _FarmerGroupsScreenState();
}

class _FarmerGroupsScreenState extends State<FarmerGroupsScreen> {
  List<FarmerGroupModel> items = [];

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
    items = await FarmerGroupModel.get_items();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text("Farmer Groups"),
          backgroundColor: CustomTheme.primary,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: get_items,
                //list grid builder
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     FarmersListScreen(items[index])));
                      },
                      child: FxCard(
                        padding: const EdgeInsets.all(8.0),
                        borderRadiusAll: 20,
                        margin: const EdgeInsets.all(8.0),
                        color: (AppConfig
                            .nice_colors[index % AppConfig.nice_colors.length]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FxText.titleLarge(
                                items[index].name,
                                textAlign: TextAlign.center,
                                color: Colors.white,
                                maxLines: 2,
                                fontWeight: 800,
                              ),
                            ),
                            const Divider(),
                            FxText.bodySmall(
                              "${items[index].registration_year} Members",
                              textAlign: TextAlign.center,
                              color: Colors.white,
                              maxLines: 2,
                              fontWeight: 800,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
