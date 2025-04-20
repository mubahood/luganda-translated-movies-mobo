import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

import 'core/app.dart';

void main() {
  runApp(
    UpgradeAlert(
      child: const MyApp(),
      barrierDismissible: false,
    ),
  );
}
