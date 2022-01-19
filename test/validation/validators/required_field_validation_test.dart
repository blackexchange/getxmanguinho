import 'package:test/test.dart';
import 'package:testes/presentation/protocols/protocols.dart';
import 'package:testes/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('SHould return null if value is not empty', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
  });

  test('SHould return null if value is empty', () {
    expect(sut.validate({'any_field': ''}), ValidationError.requiredField);
  });

  test('SHould return null if value is null', () {
    expect(sut.validate({'any_field': null}), ValidationError.requiredField);
  });
}
