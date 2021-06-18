abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<bool> get isFormValidErrorStream;

  void validateEmail(String? email);
  void validatePassword(String? password);
  void auth();

}