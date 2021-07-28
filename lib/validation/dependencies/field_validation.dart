import '../../presentation/presenters/dependencies/dependencies.dart';

abstract class FieldValidation {
  String get field;
  ValidationError? validate(Map input);
}