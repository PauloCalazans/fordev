import 'package:fordev/validation/dependencies/dependencies.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  String? validate(String? value) {
    return null;
  }
}

void main() {
  test('Should return null if email is empty', () {
      final sut = EmailValidation('any_field');

      var error = sut.validate('');

      expect(error, null);
  });

  test('Should return null if email is null', () {
    final sut = EmailValidation('any_field');

    var error = sut.validate(null);

    expect(error, null);
  });
}