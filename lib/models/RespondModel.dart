import 'dart:convert';

import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../utils/Utilities.dart';

class RespondModel {
  dynamic raw;
  int code = 0;
  String message =
      "Failed to connect to internet. Check your connection and try again";
  dynamic data;

  RespondModel(this.raw) {
    if (raw == null) {
      return;
    }
    print(raw);
    Map<String, dynamic> resp = {};
    if (raw.runtimeType.toString() != '_Map<String, dynamic>') {
      try {
        resp = jsonDecode(raw);
      } catch (e) {
        resp = {'code': 0, 'message': raw.toString(), 'data': null};
      }
    } else {
      resp = raw;
    }

    if (resp['message'] == 'Unauthenticated') {
      Utils.toast("You are not logged in.");
      Utils.logout();
      Get.off(const LoginScreen());
      return;
    }

    if (resp['code'] != null) {
      code = Utils.int_parse(resp['code'].toString());
      message = resp['message'].toString();
      data = resp['data'];
    } else if (resp['message'] != null) {
      code = Utils.int_parse(resp['code'].toString());
      message = resp['message'].toString();
      data = resp['data'];
    }
  }
}
