import 'dart:async';

import 'package:fordev/ui/pages/login/login_presenter.dart';

import '../../domain/helpers/domain_error.dart';
import '../../domain/usecases/authentication.dart';

import '../presenters/dependencies/dependencies.dart';

class StreamLoginPresenter implements LoginPresenter {
  StreamLoginPresenter({required this.validation, required this.authentication});

  final Validation validation;
  final Authentication authentication;
  StreamController<LoginState>? _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String?>? get emailErrorStream => _controller?.stream.map((state) => state.emailError).distinct();
  Stream<String?>? get passwordErrorStream => _controller?.stream.map((state) => state.passwordError).distinct();
  Stream<String?>? get mainErrorStream => _controller?.stream.map((state) => state.mainError).distinct();
  Stream<bool>? get isFormValidStream => _controller?.stream.map((state) => state.isFormValid).distinct();
  Stream<bool>? get isLoadingStream => _controller?.stream.map((state) => state.isLoading).distinct();

  void _update() => _controller?.add(_state);

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = validation.validate(field: 'email', value: email!);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = validation.validate(field: 'password', value: password);
    _update();
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(AuthenticationParams(email: _state.email!, secret: _state.password!));
    } on DomainError catch (error) {
      _state.mainError = error.description;
    }
    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }
}

class LoginState {
  String? emailError;
  String? email;
  String? passwordError;
  String? mainError;
  String? password;
  late bool isLoading;

  bool get isFormValid => emailError == null && passwordError == null && email != null && password != null;
}