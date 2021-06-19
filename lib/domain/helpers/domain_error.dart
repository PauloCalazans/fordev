enum DomainError {
  unexpected,
  invalidCredentials
}

extension DomainErrorExtension on DomainError {
  String get description {
    var descriptions = {
      DomainError.invalidCredentials: 'Credenciais inválidas.'
    };

    return descriptions[this] ?? 'Algo errado aconteceu. Tente novamente em breve.';
  }
}