import 'package:test/test.dart';
import 'package:testes/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('SHould return null if email is  empty', () {
    expect(sut.validate(''), null);
  });

  test('SHould return null if email is  null', () {
    expect(sut.validate(null), null);
  });

  test('SHould return null if email is  valid', () {
    expect(sut.validate('neville@ig.com.br'), null);
  });

  test('SHould return null if email is  invalid', () {
    expect(sut.validate('neville@ig.'), 'Campo inválido');
  });
}
