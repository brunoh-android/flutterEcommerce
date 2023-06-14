import 'package:get/get.dart';

String? emailValidator(String? email) {
  if (email == null || email.isEmpty) return 'Digite seu email';
  if (!email.isEmail) return 'Digite um email válido';

  return null;
}

String? passwordValidator(String? password) {
  if (password == null || password.isEmpty) {
    'Digite sua senha';
  }

  if (password!.length < 7) {
    'Digite uma senha de 7 caracteres ou mais';
  }
  return null;
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    'Digite um nome';
  }

  final names = name!.split(' ');

  if (names.length == 1) return 'Digite seu nome completo';

  return null;
}

String? phoneValidator(String? phone) {
  if (phone == null || phone.isEmpty) {
    'Digite o numero do celular';
  }

  if (!phone!.isPhoneNumber || phone.length < 14) {
    return 'Digite um número válido';
  }

  return null;
}

String? cpfValidator(String? cpf) {
  if (cpf == null || cpf.isEmpty) {
    'Digite o numero do CPF';
  }

  if (!cpf!.isCpf) return 'Digite um CPF válido';

  return null;
}
