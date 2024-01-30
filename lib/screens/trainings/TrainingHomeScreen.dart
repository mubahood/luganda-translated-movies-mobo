import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:omulimisa2/utils/my_colors.dart';

import '../../src/routing/routing.dart';
import 'TrainingSessionsScreen.dart';

class TrainingHomeScreen extends StatefulWidget {
  const TrainingHomeScreen({super.key});

  @override
  State<TrainingHomeScreen> createState() => _TrainingHomeScreenState();
}

class _TrainingHomeScreenState extends State<TrainingHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainings'),
        backgroundColor: MyColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: FxContainer(
                height: 100,
                onTap: () {
                  Get.toNamed(AppRouter.trainingSession);
                },
                color: const Color(0xFF015252),
                child: Center(
                    child: FxText.titleLarge(
                  'Training\nPrograms',
                  fontWeight: 600,
                  textAlign: TextAlign.center,
                  color: Colors.white,
                )),
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: FxContainer(
                height: 100,
                onTap: () {
                  Get.to(() => const TrainingSessionsScreen());
                },
                color: const Color(0xFFC58100),
                child: Center(
                    child: FxText.titleLarge(
                  'Training\nSessions',
                  fontWeight: 600,
                  textAlign: TextAlign.center,
                  color: Colors.white,
                )),
              )),
              const SizedBox(
                width: 10,
              ),
            ],
          )
        ],
      ),
    );
  }
}
