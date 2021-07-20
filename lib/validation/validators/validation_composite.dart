import '../../presentation/presenters/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;
  ValidationComposite(this.validations);

  @override
  ValidationError? validate({required String field, required String value}) {
    ValidationError? error;
    for (var validation in validations.where((val) => val.field == field)) {
      error = validation.validate(value);

      if(error != null) {
        return error;
      }
    }
    return error;
  }
}