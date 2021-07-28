import 'package:equatable/equatable.dart';

import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;
  RequiredFieldValidation(this.field);

  @override
  ValidationError? validate(Map input) {
    return input[field].isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List get props => [field];
}