import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  late EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });
  test('Should return null if email is empty', () {
      expect(sut.validate(''), null);
  });

  test('Should return null if email is null', () {
    expect(sut.validate(null), null);
  });

  test('Should return null if email is valid', () {
    expect(sut.validate('paulo.calazans@email.com'), null);
  });

  test('Should return error if email is valid', () {
    expect(sut.validate('paulo.calazans'), 'Campo inválido');
  });
}