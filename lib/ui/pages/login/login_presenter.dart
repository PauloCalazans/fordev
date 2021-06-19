abstract class LoginPresenter {
  Stream<String?> get emailErrorStream;
  Stream<String?> get passwordErrorStream;
  Stream<String?> get mainErrorController;
  Stream<bool> get isFormValidErrorStream;
  Stream<bool> get isLoadingStream;

  void validateEmail(String? email);
  void validatePassword(String? password);
  void auth();
  void dispose();

}