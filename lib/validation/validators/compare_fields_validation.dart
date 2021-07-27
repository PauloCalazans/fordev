import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String valueToCompare;

  CompareFieldsValidation({required this.field, required this.valueToCompare});

  @override
  ValidationError? validate(String? value) {
    return ValidationError.invalidField;
  }
}