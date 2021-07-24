import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../presenters/dependencies/dependencies.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({required this.validation, required this.addAccount, required this.saveCurrentAccount});

  var _emailError = Rxn<UIError>(null);
  var _nameError = Rxn<UIError>(null);
  var _passwordError = Rxn<UIError>(null);
  var _passwordConfirmationError = Rxn<UIError>(null);
  var _mainError = Rxn<UIError>(null);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  Stream<UIError?>? get emailErrorStream => _emailError.stream;
  Stream<UIError?>? get nameErrorStream => _nameError.stream;
  Stream<UIError?>? get passwordErrorStream => _passwordError.stream;
  Stream<UIError?>? get passwordConfirmationErrorStream => _passwordConfirmationError.stream;
  Stream<UIError?>? get mainErrorStream => _mainError.stream;
  Stream<bool?> get isFormValidStream => _isFormValid.stream;
  Stream<bool?> get isLoadingStream => _isLoading.stream;

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

  Future<void>? signUp() async {

    try {
      _isLoading.value = true;
      AddAccountParams params = AddAccountParams(
          name: _name!,
          email: _email!,
          password: _password!,
          passwordConfirmation: _passwordConfirmation!
      );
      var account = await addAccount.add(params);
      await saveCurrentAccount.save(account);
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.emailInUse: _mainError.value = UIError.emailInUse; break;
        default: _mainError.value = UIError.unexpected; break;
      }

      _isLoading.value = false;
    }
  }
}