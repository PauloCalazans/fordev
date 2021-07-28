import 'package:test/test.dart';
import 'package:fordev/presentation/presenters/dependencies/dependencies.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  late CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(field: 'any_field', fieldToCompare: 'other_field');
  });

  test('Should return error if values are not equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'other_value',
    };
   expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('Should return error if values are equal', () {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'any_value',
    };
    expect(sut.validate(formData), null);
  });
}