import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/presentation/presenters/dependencies/dependencies.dart';
import 'package:fordev/validation/dependencies/dependencies.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;
  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    return null;
  }
}

class MockFieldValidation extends Mock implements FieldValidation {}

void main() {

  test('Should return null if all validations returns null or empty', () {
      final validation1 = MockFieldValidation();
      when(() => validation1.field).thenReturn('any_field');
      when(() => validation1.validate(any())).thenReturn(null);
      final validation2 = MockFieldValidation();
      when(() => validation2.field).thenReturn('any_field');
      when(() => validation2.validate(any())).thenReturn('');
      final sut = ValidationComposite([validation1, validation2]);

      final error = sut.validate(field: 'any_field', value: 'any_value');

      expect(error, null);
  });
}