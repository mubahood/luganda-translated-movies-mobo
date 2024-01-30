import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/models/RespondModel.dart';
import 'package:omulimisa2/utils/Utilities.dart';
import 'package:omulimisa2/utils/my_colors.dart';

import '../../models/TrainingModel.dart';
import '../../models/TrainingSessionLocalModel.dart';
import '../pickers/FarmersPickerScreen.dart';
import 'TrainingSessionCreateBasicInformationScreen.dart';
import 'TrainingsScreen.dart';

class TrainingSessionCreateHomeScreen extends StatefulWidget {
  TrainingSessionLocalModel item;

  TrainingSessionCreateHomeScreen(this.item, {super.key});

  @override
  State<TrainingSessionCreateHomeScreen> createState() =>
      _TrainingSessionCreateHomeScreenState();
}

class _TrainingSessionCreateHomeScreenState
    extends State<TrainingSessionCreateHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.item.id < 1) {
      widget.item.id = DateTime.now().millisecondsSinceEpoch ~/ 100;
    }
    my_init();
  }

  my_init() async {
    if (widget.item.id < 1) {
      widget.item.id = DateTime.now().millisecondsSinceEpoch ~/ 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
          title: "Are you sure?",
          content: const Text("Do you want to cancel this training session?"),
          textConfirm: "Yes",
          textCancel: "No",
          confirmTextColor: Colors.white,
          buttonColor: MyColors.primary,
          onConfirm: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onCancel: () {
            //Navigator.pop(context);
          },
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Training Session Submission'),
          backgroundColor: MyColors.primary,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            ListTile(
              onTap: () async {
                TrainingModel? training =
                    await Get.to(() => TrainingsScreen(const {'picker': true}));
                if (training != null) {
                  setState(() {
                    widget.item.training_id = training.id;
                    widget.item.training_text = training.name;
                  });
                }
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '1',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Training Program',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                widget.item.training_text.isNotEmpty
                    ? widget.item.training_text
                    : 'Select a training program',
                color: Colors.black,
              ),
              trailing: widget.item.training_text.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            ListTile(
              onTap: () async {
                if (widget.item.training_text.isEmpty) {
                  Utils.toast("Please select a training program first");
                  return;
                }

                await Get.to(() => TrainingSessionCreateBasicInformationScreen(
                    {'item': widget.item}));
                setState(() {});
                //Get.toNamed(AppRouter.trainingSessionCreate);
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '2',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Basic Information',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                'Enter basic information',
                color: Colors.black,
              ),
              trailing: widget.item.hasBasicInformation()
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            ListTile(
              onTap: () async {
                if (widget.item.training_text.isEmpty) {
                  Utils.toast("Please first enter basic information");
                  return;
                }

                await Get.to(
                    () => FarmersPickerScreen(widget.item.participants_list));
                setState(() {});
                //Get.toNamed(AppRouter.trainingSessionCreate);
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '3',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Participants',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                widget.item.participants_list.isNotEmpty
                    ? '${widget.item.participants_list.length} participants selected'
                    : 'Select participants',
                color: Colors.black,
              ),
              trailing: widget.item.participants_list.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            ListTile(
              onTap: () async {

                //Get.toNamed(AppRouter.trainingSessionCreate);
              },
              leading: FxContainer(
                color: MyColors.primary,
                width: 35,
                height: 35,
                borderRadiusAll: 50,
                paddingAll: 0,
                alignment: Alignment.center,
                child: FxText.titleMedium(
                  '4',
                  color: Colors.white,
                  fontWeight: 800,
                  textAlign: TextAlign.center,
                ),
              ),
              title: FxText.bodyLarge(
                'Attendance list photos',
                fontWeight: 800,
                color: Colors.black,
              ),
              subtitle: FxText.bodySmall(
                widget.item.attendanceListPhotos.isNotEmpty
                    ? "${widget.item.attendanceListPhotosUploaded.length} of ${widget.item.attendanceListPhotos.length} photos uploaded"
                    : 'Take attendance list photos',
                color: Colors.black,
              ),
              trailing: widget.item.attendanceListPhotos.isNotEmpty
                  ? const Icon(
                      Icons.check_circle,
                      color: MyColors.primary,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
            const Spacer(),
            FxContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FxButton.block(
                      backgroundColor: MyColors.primary,
                      onPressed: () {
                        submit();
                        //Get.toNamed(AppRouter.trainingSessionCreate);
                      },
                      child: FxText.titleLarge(
                        'Submit Training Session',
                        color: Colors.white,
                        fontWeight: 800,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLoading = false;

  Future<void> submit() async {
    if (widget.item.training_text.isEmpty) {
      Utils.toast("Please select a training program first");
      return;
    }

    if (!widget.item.hasBasicInformation()) {
      Utils.toast("Please enter basic information");
      return;
    }

    if (widget.item.participants_list.isEmpty) {
      Utils.toast("Please select participants");
      return;
    }

    if (widget.item.attendanceListPhotos.isEmpty) {
      Utils.toast("Please take attendance list photos");
      return;
    }

    setState(() {
      isLoading = true;
    });

    RespondModel resp = RespondModel(
        await Utils.http_post('training-sessions', widget.item.toJson()));
    setState(() {
      isLoading = false;
    });
    Utils.toast(resp.message);
    if (resp.code != 1) {
      return;
    }
    Navigator.pop(context);
  }
}
