import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/presenters/dependencies/dependencies.dart';
import 'package:fordev/presentation/presenters/presenters.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';

class ValidationSpy extends Mock implements Validation {}

void main() {
  late ValidationSpy validation;
  late GetxSignUpPresenter sut;
  late String email;

  When mockValidationCall(String? field) => when(() =>
    validation.validate(
        field: field == null ? any(named: 'field') : field,
        value: any(named: 'value')
    )
  );

  void mockValidation({String? field, ValidationError? value}) {
    mockValidationCall(field).thenReturn(value);
  }

  setUp(() {
    validation = ValidationSpy();
    sut = GetxSignUpPresenter(
        validation: validation
    );
    email = faker.internet.email();
    mockValidation();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(() => validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalidFieldError if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, UIError.invalidField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredFieldError if email is empty', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, UIError.requiredField)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailErrorStream!.listen(expectAsync1((error) => expect(error, null)));
    sut.isFormValidStream.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

}