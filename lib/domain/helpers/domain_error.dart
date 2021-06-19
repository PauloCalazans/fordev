enum DomainError {
  unexpected,
  invalidCredentials
}

extension DomainErrorExtension on DomainError {
  String get description {
    var descriptions = {
      DomainError.invalidCredentials: 'Credenciais inválidas.',
      DomainError.unexpected: 'Houve algum erro inesperado.'
    };

    return descriptions[this] ?? '';
  }
}