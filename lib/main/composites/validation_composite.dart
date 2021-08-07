import '../../presentation/presenters/dependencies/dependencies.dart';
import '../../validation/dependencies/dependencies.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;
  ValidationComposite(this.validations);

  @override
  ValidationError? validate({required String field, required Map input}) {
    ValidationError? error;
    for (var validation in validations.where((val) => val.field == field)) {
      error = validation.validate(input);

      if(error != null) {
        return error;
      }
    }
    return error;
  }
}