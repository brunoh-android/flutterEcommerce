String authErrorsString(String? code) {
  switch (code) {
    case 'INVALID_CREDENTIALS':
      return 'Email ou senha invalidos';

    case 'Invalid session token':
      return 'Token invalido';

    case 'INVALID_FULLNAME':
      return 'Ocorreu um erro ao cadastrar usuário: Nome inválido';

    case 'INVALID_PHONE':
      return 'Ocorreu um erro ao cadastrar usuário: Telefone inválido';

    case 'INVALID_CPF':
      return 'Ocorreu um erro ao cadastrar usuário: Cpf inválido';

    default:
      return 'Um erro indefinido ocorreu';
  }
}
