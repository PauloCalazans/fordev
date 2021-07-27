import '../../validation/dependencies/dependencies.dart';
import '../../validation/validators/validators.dart';

class ValidationBuilder {

  ValidationBuilder._();

  static late ValidationBuilder _instance;
  late String fieldName;
  List<FieldValidation> validations = [];

  static ValidationBuilder field(String fieldName) {
    _instance = ValidationBuilder._();
    _instance.fieldName = fieldName;

    return _instance;
  }

  ValidationBuilder required() {
    validations.add(RequiredFieldValidation(fieldName));

    return this;
  }

  ValidationBuilder email() {
    validations.add(EmailValidation(fieldName));

    return this;
  }

  ValidationBuilder min(int size) {
    validations.add(MinLengthValidation(field: fieldName, size: size));

    return this;
  }

  List<FieldValidation> build() => validations;
}