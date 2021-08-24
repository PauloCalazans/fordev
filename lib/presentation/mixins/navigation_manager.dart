import 'package:get/get.dart';

mixin NavigationManager on GetxController {
  var _navigateTo = Rxn<String>(null);
  Stream<String?> get navigateToStream => _navigateTo.stream;
  set navigateTo(String? value) => _navigateTo.value = value;
}