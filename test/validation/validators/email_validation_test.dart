import 'package:test/test.dart';

import 'package:fordev/presentation/presenters/dependencies/dependencies.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('Should return null if email is empty', () {
      expect(sut.validate({'any_field': ''}), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate({'any_field': 'paulo.calazans@email.com'}), null);
  });

  test('Should return error if email is valid', () {
    expect(sut.validate({'any_field': 'paulo.calazans'}), ValidationError.invalidField);
  });
}