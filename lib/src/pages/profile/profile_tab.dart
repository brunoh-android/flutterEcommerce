import 'package:app_quitanda/src/pages/auth/controller/auth_controller.dart';
import 'package:app_quitanda/src/pages/common_widgets/custom_text_field.dart';
import 'package:app_quitanda/src/services/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final authContoller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prefil do Usuário'),
        actions: [
          IconButton(
            onPressed: () {
              authContoller.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          CustomTextField(
              readOnly: true,
              icon: Icons.email,
              label: 'Email',
              initialValue: authContoller.user.email),
          CustomTextField(
              readOnly: true,
              icon: Icons.person,
              label: 'Nome',
              initialValue: authContoller.user.name),
          CustomTextField(
              readOnly: true,
              icon: Icons.phone,
              label: 'Celular',
              initialValue: authContoller.user.phone),
          CustomTextField(
              readOnly: true,
              icon: Icons.file_copy,
              label: 'CPF',
              isSecret: true,
              initialValue: authContoller.user.cpf),
          SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () {
                  updatePassWord();
                },
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: const Text('Atualizar senha'),
              ))
        ],
      ),
    );
  }

  Future<bool?> updatePassWord() {
    final newPasswordController = TextEditingController();
    final currentPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Atualização de senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        CustomTextField(
                            controller: currentPasswordController,
                            icon: Icons.lock,
                            label: 'Senha atual',
                            validator: passwordValidator,
                            isSecret: true),
                        CustomTextField(
                            controller: newPasswordController,
                            icon: Icons.lock_outline,
                            label: 'Nova senha',
                            validator: passwordValidator,
                            isSecret: true),
                        CustomTextField(
                            icon: Icons.lock_outline,
                            label: 'Confirmar senha',
                            validator: (password) {
                              final result = passwordValidator(password);

                              if (result != null) {
                                return result;
                              }
                              if (password != newPasswordController.text) {
                                return 'As senhas não são iguais';
                              }
                              return null;
                            },
                            isSecret: true),
                        SizedBox(
                          height: 45,
                          child: Obx(
                            () => ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: authContoller.isLoading.value
                                    ? null
                                    : () {
                                        if (formKey.currentState!.validate()) {
                                          authContoller.changePassword(
                                              currentPassword:
                                                  currentPasswordController
                                                      .text,
                                              newPassword:
                                                  newPasswordController.text);
                                        }
                                      },
                                child: authContoller.isLoading.value
                                    ? const CircularProgressIndicator()
                                    : const Text('Atualizar')),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
