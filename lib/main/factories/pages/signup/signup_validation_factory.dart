import '../../../../validation/dependencies/dependencies.dart';
import '../../../../presentation/presenters/presenters.dart';
import '../../../../validation/validators/validators.dart';
import '../../../builders/builders.dart';

Validation makeSignUpValidation() => ValidationComposite(makeSignUpValidations());

List<FieldValidation> makeSignUpValidations() {
  return [
    ...ValidationBuilder.field('name').required().min(3).build(),
    ...ValidationBuilder.field('email').required().email().build(),
    ...ValidationBuilder.field('password').required().min(3).build(),
    ...ValidationBuilder.field('passwordConfirmation').required().sameAs('password').build()
  ];
}