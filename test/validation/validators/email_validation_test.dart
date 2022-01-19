import 'package:test/test.dart';
import 'package:testes/presentation/protocols/protocols.dart';
import 'package:testes/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('SHould return null on invalid case', () {
    expect(sut.validate({}), null);
  });

  test('SHould return null if email is  empty', () {
    expect(sut.validate({'any_field': ''}), null);
  });

  test('SHould return null if email is  null', () {
    expect(sut.validate({'any_field': null}), null);
  });

  test('SHould return null if email is  valid', () {
    expect(sut.validate({'any_field': 'neville@ig.com.br'}), null);
  });

  test('SHould return null if email is  invalid', () {
    expect(sut.validate({'any_field': 'neville@ig.'}),
        ValidationError.invalidField);
  });
}
