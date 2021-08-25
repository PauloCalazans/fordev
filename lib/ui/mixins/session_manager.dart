import 'package:get/get.dart';

mixin SessionManager {
  void handleSessionExpired(Stream<bool?> stream) {
    stream.listen((isSessionExpired) {
      if(isSessionExpired == true) {
        Get.offAllNamed('/login');
      }
    });
  }
}