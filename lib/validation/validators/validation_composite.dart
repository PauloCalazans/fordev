import '../../presentation/presenters/dependencies/dependencies.dart';
import '../dependencies/dependencies.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;
  ValidationComposite(this.validations);

  @override
  String? validate({required String field, required String value}) {
    String? error;
    for (var validation in validations.where((val) => val.field == field)) {
      error = validation.validate(value);

      if(error?.isNotEmpty == true) {
        return error;
      }
    }
    return error;
  }
}