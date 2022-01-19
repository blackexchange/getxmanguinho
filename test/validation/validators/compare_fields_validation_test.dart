import 'package:test/test.dart';

import 'package:testes/presentation/protocols/protocols.dart';
import 'package:testes/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
        field: 'any_field', fieldToCompare: 'other_field');
  });
  test('SHould null on invalid cases', () {
    expect(sut.validate({'any_field': 'any_value'}), null);
    expect(sut.validate({'other_field': 'any_value'}), null);
    expect(sut.validate({}), null);
  });
  test('SHould return error if value is note equal', () {
    final formData = {'any_field': 'any_value', 'other_field': 'other_value'};
    expect(sut.validate(formData), ValidationError.invalidField);
  });

  test('SHould return error if value equals', () {
    final formData = {'any_field': 'any_value', 'other_field': 'any_value'};

    expect(sut.validate(formData), null);
  });
}
