import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:testes/presentation/protocols/protocols.dart';
import 'package:testes/validation/validators/validators.dart';

void main() {
  MinLengthValidation sut;

  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('SHould return error if value is  empty', () {
    final error = sut.validate({'any_field': ''});
    expect(error, ValidationError.invalidField);
  });

  test('SHould return error if value is  null', () {
    final error = sut.validate({'any_field': null});
    expect(error, ValidationError.invalidField);
  });

  test('SHould return error if value is  < min size', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(4, min: 1)}),
        ValidationError.invalidField);
  });

  test('SHould return null if value equals', () {
    expect(sut.validate({'any_field': faker.randomGenerator.string(5, min: 5)}),
        null);
  });

  test('SHould return null if value > max', () {
    expect(
        sut.validate({'any_field': faker.randomGenerator.string(10, min: 6)}),
        null);
  });
}
