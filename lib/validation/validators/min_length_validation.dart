import 'package:equatable/equatable.dart';

import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class MinLengthValidation extends Equatable  implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({required this.field, required this.size});

  @override
  ValidationError? validate(Map input) {
    return input[field] != null && input[field].length >= size ? null : ValidationError.invalidField;
  }

  List<Object?> get props => [field, size];
}