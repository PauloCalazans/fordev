import 'package:equatable/equatable.dart';

import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class CompareFieldsValidation extends Equatable implements FieldValidation {
  final String field;
  final String fieldToCompare;

  CompareFieldsValidation({required this.field, required this.fieldToCompare});

  @override
  ValidationError? validate(Map input) => input[field] != null &&
        input[fieldToCompare] != null &&
        input[field] != input[fieldToCompare] ?
        ValidationError.invalidField : null;

  List get props => [field, fieldToCompare];
}