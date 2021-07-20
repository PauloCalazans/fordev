import 'package:equatable/equatable.dart';

import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;
  RequiredFieldValidation(this.field);

  @override
  ValidationError? validate(String? value) {
    return value?.isNotEmpty == true ? null : ValidationError.requiredField;
  }

  @override
  List get props => [field];
}