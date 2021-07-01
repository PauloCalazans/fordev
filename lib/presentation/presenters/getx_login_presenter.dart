import 'package:fordev/domain/usecases/save_current_account.dart';
import 'package:get/get.dart';

import '../../ui/pages/login/login_presenter.dart';
import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';

import '../presenters/dependencies/dependencies.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  GetxLoginPresenter({required this.validation, required this.authentication, required this.saveCurrentAccount});

  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String? _password;
  String? _email;

  var _emailError = RxnString(null);
  var _passwordError = RxnString(null);
  var _mainError = RxnString(null);
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<String?>? get emailErrorStream => _emailError.stream;
  Stream<String?>? get passwordErrorStream => _passwordError.stream;
  Stream<String?>? get mainErrorStream => _mainError.stream;
  Stream<bool?> get isFormValidStream => _isFormValid.stream;
  Stream<bool?> get isLoadingStream => _isLoading.stream;

  void validateEmail(String email) {
    _email = email;
    _emailError.value = validation.validate(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = validation.validate(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null && _passwordError.value == null && _email != null && _password != null;
  }

  Future<void> auth() async {
    _isLoading.value = true;
    try {
      var accountEntity = await authentication.auth(AuthenticationParams(email: _email!, secret: _password!));
      await saveCurrentAccount.save(accountEntity!);
    } on DomainError catch (error) {
      _mainError.value = error.description;
    }
    _isLoading.value = false;
  }

  void dispose() {}
}