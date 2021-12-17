import 'package:testes/domain/helpers/helpers.dart';

enum DomainError { unexpected, invalidCredentials }

extension DomainErrorExtension on DomainError {
  String get description {
    switch (this) {
      case DomainError.invalidCredentials:
        return 'Credenciais inválidas.';
        break;
      default:
        return 'Algo errado aconteceu.';
    }
  }
}
