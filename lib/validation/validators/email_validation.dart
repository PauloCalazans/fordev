import 'package:equatable/equatable.dart';

import '../../presentation/presenters/dependencies/dependencies.dart';

import '../dependencies/dependencies.dart';

class EmailValidation extends Equatable implements FieldValidation {
  @override
  final String field;

  EmailValidation(this.field);

  @override
  ValidationError? validate(Map input) {
    final regex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final isValid = input[field]?.isNotEmpty != true || regex.hasMatch(input[field]);
    return isValid ? null : ValidationError.invalidField;
  }

  @override
  List get props => [field];
}