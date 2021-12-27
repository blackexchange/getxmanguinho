import 'package:test/test.dart';
import 'package:testes/main/factories/pages/login/login.dart';
import 'package:testes/validation/validators/validators.dart';

void main() {
  test('Should retutrn corret validations', () {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password')
    ]);
  });
}
