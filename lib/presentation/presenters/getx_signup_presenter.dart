import 'package:fordev/presentation/mixins/form_manager.dart';
import 'package:fordev/presentation/mixins/mixins.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/errors/errors.dart';
import '../presenters/dependencies/dependencies.dart';

import '../mixins/loading_manager.dart';

class GetxSignUpPresenter extends GetxController with LoadingManager, FormManager, NavigationManager, MainErrorManager implements SignUpPresenter {
  final Validation validation;
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  GetxSignUpPresenter({required this.validation, required this.addAccount, required this.saveCurrentAccount});

  var _emailError = Rxn<UIError>(null);
  var _nameError = Rxn<UIError>(null);
  var _passwordError = Rxn<UIError>(null);
  var _passwordConfirmationError = Rxn<UIError>(null);

  String? _name;
  String? _email;
  String? _password;
  String? _passwordConfirmation;

  Stream<UIError?>? get emailErrorStream => _emailError.stream;
  Stream<UIError?>? get nameErrorStream => _nameError.stream;
  Stream<UIError?>? get passwordErrorStream => _passwordError.stream;
  Stream<UIError?>? get passwordConfirmationErrorStream => _passwordConfirmationError.stream;

  void validateName(String name) {
    _name = name;
    _nameError.value = _validateField('name');
    _validateForm();
  }

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateField('email');
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateField('password');
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    _passwordConfirmationError.value = _validateField('passwordConfirmation');
    _validateForm();
  }

  UIError? _validateField(String field) {
    final Map formData = {
      'name': _name,
      'email': _email,
      'password': _password,
      'passwordConfirmation': _passwordConfirmation,
    };
    final error = validation.validate(field: field, input: formData);

    final options = {
      ValidationError.invalidField: UIError.invalidField,
      ValidationError.requiredField: UIError.requiredField
    };
    return options[error] ?? null;
  }

  void _validateForm() {
    isFormValid =
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
      mainError = null;
      isLoading = true;
      AddAccountParams params = AddAccountParams(
          name: _name!,
          email: _email!,
          password: _password!,
          passwordConfirmation: _passwordConfirmation!
      );
      var account = await addAccount.add(params);
      await saveCurrentAccount.save(account);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.emailInUse: mainError = UIError.emailInUse; break;
        default: mainError = UIError.unexpected; break;
      }

      isLoading = false;
    }
  }

  Future<void>? goToLogin() {
    navigateTo = '/login';
  }
}