import 'package:get/get.dart';

import '../../ui/helpers/errors/errors.dart';

import '../presenters/dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController {
  GetxSignUpPresenter({required this.validation});

  final Validation validation;

  var _emailError = Rxn<UIError>(null);
  var _nameError = Rxn<UIError>(null);
  var _passwordError = Rxn<UIError>(null);
  var _passwordConfirmationError = Rxn<UIError>(null);
  var _isFormValid = false.obs;

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  Stream<UIError?>? get emailErrorStream => _emailError.stream;
  Stream<UIError?>? get nameErrorStream => _nameError.stream;
  Stream<UIError?>? get passwordErrorStream => _passwordError.stream;
  Stream<UIError?>? get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<bool?> get isFormValidStream => _isFormValid.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField(field: 'passwordConfirmation', value: passwordConfirmation);
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
    _isFormValid.value =
        _nameError.value == null
        && _emailError.value == null
        && _passwordError.value == null
        && _passwordConfirmationError.value == null
        && _name != null
        && _email != null
        && _password != null
        && _passwordConfirmation != null;
  }
}