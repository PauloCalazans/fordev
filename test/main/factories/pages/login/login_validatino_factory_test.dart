import 'package:fordev/main/factories/factories.dart';
import 'package:fordev/validation/validators/email_validation.dart';
import 'package:fordev/validation/validators/required_field_validation.dart';
import 'package:test/test.dart';

void main() {
  test('Should return the correct validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password')
    ]);
  });
}