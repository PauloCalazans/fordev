import 'package:fordev/ui/helpers/helpers.dart';

enum UIError {
  requiredField,
  invalidField,

  unexpected,
  invalidCredentials
}

extension DomainErrorExtension on UIError {
  String get description {
    var descriptions = {
      UIError.requiredField: R.strings.msgRequiredField,
      UIError.invalidField: R.strings.msgInvalidField,
      UIError.invalidCredentials: R.strings.msgInvalidCredentials,
    };

    return descriptions[this] ?? R.strings.msgUnexpectedError;
  }
}