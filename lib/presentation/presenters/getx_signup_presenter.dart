import 'package:get/get.dart';

import '../../ui/helpers/errors/errors.dart';

import '../presenters/dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController {
  GetxSignUpPresenter({required this.validation});

  final Validation validation;

  var _emailError = Rxn<UIError>(null);
  var _isFormValid = false.obs;

  Stream<UIError?>? get emailErrorStream => _emailError.stream;
  Stream<bool?> get isFormValidStream => _isFormValid.stream;

  void validateEmail(String email) {
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  UIError? _validateField({required String field, required String value}) {
    final error = validation.validate(field: field, value: value);

    final options = {
      ValidationError.invalidField: UIError.invalidField,
      ValidationError.requiredField: UIError.requiredField
    };
    return options[error] ?? null;
  }

  void _validateForm() {
    _isFormValid.value = false;
  }
}