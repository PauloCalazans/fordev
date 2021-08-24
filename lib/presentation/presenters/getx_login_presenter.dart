import 'package:get/get.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../mixins/mixins.dart';

import '../presenters/dependencies/dependencies.dart';

class GetxLoginPresenter extends GetxController with LoadingManager, NavigationManager, MainErrorManager, FormManager implements LoginPresenter {
  GetxLoginPresenter({required this.validation, required this.authentication, required this.saveCurrentAccount});

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _password;
  String? _email;

  var _emailError = Rxn<UIError>(null);
  var _passwordError = Rxn<UIError>(null);

  Stream<UIError?>? get emailErrorStream => _emailError.stream;
  Stream<UIError?>? get passwordErrorStream => _passwordError.stream;

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

  UIError? _validateField(String field) {
    final error = validation.validate(field: field, input: { 'email': _email, 'password': _password });

    final options = {
      ValidationError.invalidField: UIError.invalidField,
      ValidationError.requiredField: UIError.requiredField
    };
    return options[error] ?? null;
  }

  void _validateForm() {
    isFormValid = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  Future<void> auth() async {
    try {
      mainError = null;
      isLoading = true;
      var accountEntity = await authentication.auth(AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(accountEntity);
      navigateTo = '/surveys';
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.invalidCredentials: mainError = UIError.invalidCredentials; break;
        default: mainError = UIError.unexpected; break;
      }

      isLoading = false;
    }
  }

  Future<void>? goToSignUp() {
    navigateTo = '/signup';
  }
}