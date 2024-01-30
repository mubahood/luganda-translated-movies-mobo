import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/CropModel.dart';

import '../../models/GardenModel.dart';
import '../../utils/CustomTheme.dart';
import '../pickers/CropPickerScreen.dart';

class GardenCreateBasicInformationScreen extends StatefulWidget {
  GardenModel garden;

  GardenCreateBasicInformationScreen(
    this.garden, {
    Key? key,
  }) : super(key: key);

  @override
  GardenCreateBasicInformationScreenState createState() =>
      GardenCreateBasicInformationScreenState();
}

class GardenCreateBasicInformationScreenState
    extends State<GardenCreateBasicInformationScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";

  Future<bool> init_form() async {
    return true;
  }

  @override
  void initState() {
    super.initState();
    initFuture = init_form();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          "Session Basic Information",
          fontSize: 20,
          color: Colors.white,
          fontWeight: 700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomTheme.primary,
        actions: [
          is_loading
              ? const Padding(
                  padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                    ),
                  ),
                )
              : FxButton.text(
                  onPressed: () {
                    //POP
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.white,
                  child: FxText.bodyLarge(
                    "SAVE",
                    color: Colors.white,
                    fontWeight: 800,
                  ))
        ],
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return FormBuilder(
              key: _fKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            FormBuilderDateTimePicker(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("Planting Date").capitalize!,
                              ),
                              keyboardType: TextInputType.datetime,
                              inputType: InputType.date,
                              lastDate: DateTime.now(),
                              textCapitalization: TextCapitalization.words,
                              name: "created_at",
                              initialValue: widget.garden.created_at.isEmpty
                                  ? DateTime.now()
                                  : DateTime.parse(widget.garden.created_at),
                              onChanged: (x) {
                                widget.garden.created_at = x.toString();
                              },
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("Select crop planted")
                                    .capitalize!,
                              ),
                              initialValue: widget.garden.crop_text,
                              textCapitalization: TextCapitalization.words,
                              name: "crop_text",
                              readOnly: true,
                              onTap: () async {
                                CropModel? crop = await Get.to(
                                    () => CropPickerScreen(CropModel()));
                                if (crop != null) {
                                  widget.garden.crop_id = crop.id.toString();
                                  widget.garden.crop_text = crop.name;
                                  _fKey.currentState!.patchValue({
                                    "crop_text": widget.garden.crop_text,
                                  });
                                }
                                setState(() {});
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("Garden name").capitalize!,
                              ),
                              initialValue: widget.garden.name,
                              textCapitalization: TextCapitalization.words,
                              name: "name",
                              onChanged: (x) {
                                widget.garden.name = x.toString();
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            //FormBuilderChoiceChip for soil_type
                            FormBuilderChoiceChip(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("Soil type").capitalize!,
                              ),
                              name: "soil_type",
                              initialValue: widget.garden.soil_type,
                              spacing: 10,
                              selectedColor: CustomTheme.primary,
                              backgroundColor: Colors.grey.shade100,
                              options: const [
                                FormBuilderChipOption(
                                  value: "Loamy",
                                ),
                                FormBuilderChipOption(
                                  value: "Clay",
                                ),
                                FormBuilderChipOption(
                                  value: "Sandy",
                                ),
                                FormBuilderChipOption(
                                  value: "Peaty",
                                ),
                              ],
                              onChanged: (x) {
                                widget.garden.soil_type = x.toString();
                              },
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("Soil PH").capitalize!,
                              ),
                              initialValue: widget.garden.soil_ph,
                              textCapitalization: TextCapitalization.words,
                              name: "soil_ph",
                              onChanged: (x) {
                                widget.garden.soil_ph = x.toString();
                              },
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label:
                                    GetStringUtils("Soil Moisture").capitalize!,
                              ),
                              initialValue: widget.garden.soil_ph,
                              textCapitalization: TextCapitalization.words,
                              name: "soil_moisture",
                              onChanged: (x) {
                                widget.garden.soil_moisture = x.toString();
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_3(
                                label: GetStringUtils("Garden Details")
                                    .capitalize!,
                              ),
                              initialValue: widget.garden.details,
                              textCapitalization: TextCapitalization.words,
                              name: "details",
                              onChanged: (x) {
                                widget.garden.details = x.toString();
                              },
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FxContainer(
                      color: Colors.white,
                      borderRadiusAll: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: FxButton.block(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: CustomTheme.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FxText.titleLarge(
                                'SAVE',
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(
                                FeatherIcons.check,
                                color: Colors.white,
                              )
                            ],
                          )))
                ],
              ),
            );
          }),
    );
  }
}
