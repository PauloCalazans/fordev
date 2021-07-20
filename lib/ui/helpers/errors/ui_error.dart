enum UIError {
  requiredField,
  invalidField,

  unexpected,
  invalidCredentials
}

extension DomainErrorExtension on UIError {
  String get description {
    var descriptions = {
      UIError.requiredField: 'Campo obrigatório',
      UIError.invalidField: 'Campo inválido',
      UIError.invalidCredentials: 'Credenciais inválidas',
    };

    return descriptions[this] ?? 'Algo errado aconteceu. Tente novamente em breve.';
  }
}