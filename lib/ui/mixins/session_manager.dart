import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/components.dart';

mixin SessionManager {
  void handleSessionExpired(Stream<bool?> stream) {
    stream.listen((isSessionExpired) {
      if(isSessionExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }
}