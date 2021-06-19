// Mocks generated by Mockito 5.0.10 from annotations
// in fordev/test/ui/pages/login_page_teste.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:fordev/ui/pages/login/login_presenter.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: comment_references
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

/// A class which mocks [LoginPresenter].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginPresenter extends _i1.Mock implements _i2.LoginPresenter {
  MockLoginPresenter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<String?> get emailErrorStream =>
      (super.noSuchMethod(Invocation.getter(#emailErrorStream),
          returnValue: Stream<String?>.empty()) as _i3.Stream<String?>);
  @override
  _i3.Stream<String?> get passwordErrorStream =>
      (super.noSuchMethod(Invocation.getter(#passwordErrorStream),
          returnValue: Stream<String?>.empty()) as _i3.Stream<String?>);
  @override
  _i3.Stream<String?> get mainErrorController =>
      (super.noSuchMethod(Invocation.getter(#mainErrorController),
          returnValue: Stream<String?>.empty()) as _i3.Stream<String?>);
  @override
  _i3.Stream<bool> get isFormValidErrorStream =>
      (super.noSuchMethod(Invocation.getter(#isFormValidErrorStream),
          returnValue: Stream<bool>.empty()) as _i3.Stream<bool>);
  @override
  _i3.Stream<bool> get isLoadingStream =>
      (super.noSuchMethod(Invocation.getter(#isLoadingStream),
          returnValue: Stream<bool>.empty()) as _i3.Stream<bool>);
  @override
  void validateEmail(String? email) =>
      super.noSuchMethod(Invocation.method(#validateEmail, [email]),
          returnValueForMissingStub: null);
  @override
  void validatePassword(String? password) =>
      super.noSuchMethod(Invocation.method(#validatePassword, [password]),
          returnValueForMissingStub: null);
  @override
  void auth() => super.noSuchMethod(Invocation.method(#auth, []),
      returnValueForMissingStub: null);
}
