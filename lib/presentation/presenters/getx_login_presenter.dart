import 'package:get/get.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../presenters/dependencies/dependencies.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  GetxLoginPresenter({required this.validation, required this.authentication, required this.saveCurrentAccount});

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _password;
  String? _email;

  var _emailError = Rxn<UIError>(null);
  var _passwordError = Rxn<UIError>(null);
  var _mainError = Rxn<UIError>(null);
  var _navigateTo = RxnString(null);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UIError?>? get emailErrorStream => _emailError.stream;
  Stream<UIError?>? get passwordErrorStream => _passwordError.stream;
  Stream<UIError?>? get mainErrorStream => _mainError.stream;
  Stream<String?>? get navigateToStream => _navigateTo.stream;
  Stream<bool?> get isFormValidStream => _isFormValid.stream;
  Stream<bool?> get isLoadingStream => _isLoading.stream;

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
    _isFormValid.value = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  Future<void> auth() async {
    try {
      _isLoading.value = true;
      var accountEntity = await authentication.auth(AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(accountEntity);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch(error) {
        case DomainError.invalidCredentials: _mainError.value = UIError.invalidCredentials; break;
        default: _mainError.value = UIError.unexpected; break;
      }

      _isLoading.value = false;
    }
  }

  Future<void>? goToSignUp() {
    _navigateTo.value = '/signup';
  }
}