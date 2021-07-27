import 'package:equatable/equatable.dart';

import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class MinLengthValidation extends Equatable  implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({required this.field, required this.size});

  @override
  ValidationError? validate(String? value) {
    return value != null && value.length >= size ? null : ValidationError.invalidField;
  }

  List<Object?> get props => [field, size];
}