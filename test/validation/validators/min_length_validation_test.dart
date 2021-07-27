import 'package:test/test.dart';

import 'package:fordev/validation/dependencies/dependencies.dart';
import 'package:fordev/presentation/presenters/dependencies/dependencies.dart';
import 'package:fordev/validation/validators/validators.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({required this.field, required this.size});

  @override
  ValidationError? validate(String? value) {
    return ValidationError.invalidField;
  }

}

void main() {
  late MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('Should return error if value is empty', () {
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('Should return error if value is null', () {
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });
}