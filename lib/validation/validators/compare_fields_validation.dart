import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class CompareFieldsValidation implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({required this.field, required this.fieldToCompare});

  @override
  ValidationError? validate(Map input) {
    return input[field] == input[fieldToCompare] ? null : ValidationError.invalidField;
  }
}