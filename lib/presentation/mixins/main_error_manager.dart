import 'package:get/get.dart';
import '../../../ui/helpers/errors/errors.dart';

mixin MainErrorManager on GetxController {
  var _mainError = Rxn<UIError>(null);
  Stream<UIError?> get mainErrorStream => _mainError.stream;
  set mainError(UIError? value) => _mainError.value = value;
}